package logger

import (
	"log/slog"
	"net/http"

	"github.com/gin-gonic/gin"
)

func LogFormatter(params gin.LogFormatterParams) string {
	switch {
	case http.StatusInternalServerError <= params.StatusCode:
		slog.ErrorContext(params.Request.Context(), params.ErrorMessage,
			"status", params.StatusCode,
			"method", params.Method,
			"path", params.Path,
			"ip", params.ClientIP,
			"latency_ms", params.Latency.Milliseconds(),
			"user_agent", params.Request.UserAgent(),
			"host", params.Request.Host,
		)
		return ""

	case params.StatusCode >= http.StatusBadRequest && params.StatusCode <= http.StatusInternalServerError:
		slog.WarnContext(params.Request.Context(), params.ErrorMessage,
			"status", params.StatusCode,
			"method", params.Method,
			"path", params.Path,
			"ip", params.ClientIP,
			"latency_ms", params.Latency.Milliseconds(),
			"user_agent", params.Request.UserAgent(),
			"host", params.Request.Host,
		)
		return ""

	default:
		slog.InfoContext(params.Request.Context(), "access",
			"status", params.StatusCode,
			"method", params.Method,
			"path", params.Path,
			"ip", params.ClientIP,
			"latency_ms", params.Latency.Milliseconds(),
			"user_agent", params.Request.UserAgent(),
			"host", params.Request.Host,
		)
		return ""
	}
}
