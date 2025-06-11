package configuration

import (
	"context"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/kelseyhightower/envconfig"
)

var globalConfig Config

type Config struct {
	AWSConfig aws.Config
	Logging   string `envconfig:"LOGGING" default:"off"`

	API struct {
		Env         string `envconfig:"API_ENV" default:"dev"`
		Port        string `envconfig:"API_PORT" default:"8080"`
		ServiceName string `envconfig:"API_SERVICE_NAME" default:"shop-api"`
	}

	CoreDB struct {
		Host string `json:"host"`
		Port string `json:"port"`
		User string `json:"username"`
		Pass string `json:"password"`
		Name string `json:"dbname"`
	}
}

func Get() Config { return globalConfig }

func Load(ctx context.Context) (Config, error) {
	envconfig.MustProcess("", &globalConfig)
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	env := globalConfig.API.Env
	if err := loadAWSConf(ctx, env); err != nil {
		return globalConfig, err
	}

	if err := batchGetSecrets(
		ctx,
		globalConfig.AWSConfig,
		map[string]any{
			fmt.Sprintf("core/%s/rds-cluster", env): &globalConfig.CoreDB,
		},
	); err != nil {
		return Config{}, err
	}

	return globalConfig, nil
}
