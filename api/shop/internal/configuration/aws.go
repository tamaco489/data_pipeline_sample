package configuration

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/config"
)

func loadAWSConf(ctx context.Context) error {
	const awsDefaultRegion = "ap-northeast-1"
	awsCfg, err := config.LoadDefaultConfig(ctx, config.WithRegion(awsDefaultRegion))
	if err != nil {
		return fmt.Errorf("failed to load aws config: %w", err)
	}

	globalConfig.AWSConfig = awsCfg

	return nil
}
