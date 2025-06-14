package usecase

import (
	"fmt"
	"log/slog"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"

	repository_gen_sqlc "github.com/tamaco489/data_pipeline_sample/api/shop/internal/repository/gen_sqlc"
)

func (cu *chargeUseCase) CreateCharge(ctx *gin.Context, uid string, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error) {

	// Adding a 1000ms delay to simulate a performance-challenged API that handles a large number of record operations.
	time.Sleep(1000 * time.Millisecond)

	// *************** [Request validation] ***************
	// Get pending reservations
	pendingReservations, err := cu.queries.GetPendingReservationByIDAndUserID(ctx, cu.dbtx, repository_gen_sqlc.GetPendingReservationByIDAndUserIDParams{
		ReservationID: request.Body.ReservationId,
		UserID:        uid,
		Status:        repository_gen_sqlc.ReservationsStatusPending,
	})
	if err != nil {
		return gen.CreateCharge500Response{}, fmt.Errorf("failed to get pending reservation: %w", err)
	}

	// Return 404 error if no pending reservations are found
	if len(pendingReservations) == 0 {
		return gen.CreateCharge404Response{}, nil
	}

	// Return 409 error if a charge already exists for the reservation_id to prevent duplicate charges
	exists, err := cu.queries.ExistsChargeByReservationIDAndUserID(ctx, cu.dbtx, repository_gen_sqlc.ExistsChargeByReservationIDAndUserIDParams{
		ReservationID: request.Body.ReservationId,
		UserID:        uid,
	})
	if err != nil {
		return gen.CreateCharge500Response{}, fmt.Errorf("failed to check if charge exists: %w", err)
	}
	if exists {
		return gen.CreateCharge409Response{}, nil
	}

	// *************** [Charge processing] ***************
	// Save charge
	chargeID, err := cu.saveCharge(ctx, uid, request.Body.ReservationId, pendingReservations)
	if err != nil {
		return gen.CreateCharge500Response{}, fmt.Errorf("failed to save charge: %w", err)
	}

	slog.InfoContext(ctx, "completed charge processing", "reservation_id", request.Body.ReservationId, "charge_id", chargeID)

	return gen.CreateCharge204Response{}, nil
}

func (cu *chargeUseCase) saveCharge(ctx *gin.Context, uid string, reservationID string, pendingReservations []repository_gen_sqlc.GetPendingReservationByIDAndUserIDRow) (string, error) {
	// Calculate the amount of the charge
	var amount uint32 = 0
	for _, v := range pendingReservations {
		amount += v.UnitPrice * v.Quantity
	}

	// Start a transaction
	tx, err := cu.db.BeginTx(ctx, nil)
	if err != nil {
		return "", fmt.Errorf("failed to begin transaction: %w", err)
	}

	// Rollback the transaction when the function exits
	defer func() { _ = tx.Rollback() }()

	// Update the status of reservation_id to confirmed
	if err := cu.queries.UpdateReservationStatus(ctx, tx, repository_gen_sqlc.UpdateReservationStatusParams{
		ReservationID: reservationID,
		Status:        repository_gen_sqlc.ReservationsStatusConfirmed,
	}); err != nil {
		return "", fmt.Errorf("failed to update reservation status: %w", err)
	}

	// Generate a charge_id
	chargeID := uuid.New().String()

	// Create a charge
	if err = cu.queries.CreateCharge(ctx, tx, repository_gen_sqlc.CreateChargeParams{
		ID:            chargeID,
		ReservationID: reservationID,
		UserID:        uid,
		Amount:        amount,
		Status:        repository_gen_sqlc.ChargesStatusUnpaid,
	}); err != nil {
		return "", fmt.Errorf("failed to create charge: %w", err)
	}

	// Create charge_products
	for _, v := range pendingReservations {
		if err = cu.queries.CreateChargeProduct(ctx, tx, repository_gen_sqlc.CreateChargeProductParams{
			ChargeID:  chargeID,
			ProductID: v.ProductID,
			Quantity:  v.Quantity,
			UnitPrice: v.UnitPrice,
		}); err != nil {
			return "", fmt.Errorf("failed to create charge product: %w", err)
		}
	}

	// Commit the transaction
	if err := tx.Commit(); err != nil {
		return "", fmt.Errorf("failed to transaction commit: %w", err)
	}

	return chargeID, nil
}
