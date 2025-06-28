package controller

import (
	"fmt"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/configuration"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/gen"
	"github.com/tamaco489/data_pipeline_sample/api/shop/internal/library/logger"

	repository_gen_sqlc "github.com/tamaco489/data_pipeline_sample/api/shop/internal/repository/gen_sqlc"
	repository_store "github.com/tamaco489/data_pipeline_sample/api/shop/internal/repository/store"
)

func NewShopAPIServer(cnf configuration.Config) (*http.Server, error) {
	corsCnf := NewCorsConfig()

	r := gin.New()
	r.Use(gin.LoggerWithFormatter(logger.LogFormatter))
	r.Use(cors.New(corsCnf))
	r.Use(gin.Recovery())

	// new mysql
	db := repository_store.InitDB()
	queries := repository_gen_sqlc.New()

	apiController, err := NewControllers(cnf, db, *queries)
	if err != nil {
		return nil, fmt.Errorf("failed to new controllers %v", err)
	}

	strictServer := gen.NewStrictHandler(apiController, nil)

	gen.RegisterHandlersWithOptions(
		r,
		strictServer,
		gen.GinServerOptions{
			BaseURL:     "/shop/",
			Middlewares: []gen.MiddlewareFunc{},
			ErrorHandler: func(ctx *gin.Context, err error, i int) {
				_ = ctx.Error(err)
				ctx.JSON(i, gin.H{"msg": err.Error()})
			},
		},
	)

	server := &http.Server{
		Handler: r,
		Addr:    fmt.Sprintf(":%s", cnf.API.Port),
	}

	return server, nil
}

func NewCorsConfig() cors.Config {
	return cors.Config{
		// Specify allowed origins (temporarily allow all)
		AllowOrigins: []string{"*"},

		// Specify allowed methods
		AllowMethods: []string{
			"GET",
			"POST",
			"PUT",
			"DELETE",
			"HEAD",
			"OPTIONS",
		},

		// Specify allowed headers
		AllowHeaders: []string{
			"Origin",
			"Content-Length",
			"Content-Type",
			"Authorization",
			"Access-Control-Allow-Origin",
		},

		// Specify exposed headers
		ExposeHeaders: []string{"Content-Length"},

		// Allow credentials
		AllowCredentials: false,

		// Specify cache duration for preflight requests (seconds)
		MaxAge: 86400,
	}
}
