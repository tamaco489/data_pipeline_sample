package configuration

import (
	"context"
	"encoding/json"
	"fmt"
	"maps"
	"slices"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
)

func batchGetSecrets(ctx context.Context, cfg aws.Config, secrets map[string]any) error {
	svc := secretsmanager.NewFromConfig(cfg)
	page := secretsmanager.NewBatchGetSecretValuePaginator(svc, &secretsmanager.BatchGetSecretValueInput{
		SecretIdList: slices.Collect(maps.Keys(secrets)),
	})
	hasNext := true
	for hasNext {
		output, err := page.NextPage(ctx)
		if err != nil {
			return fmt.Errorf("batch get secrets: %w", err)
		}
		if len(output.Errors) != 0 {
			return fmt.Errorf("batch get secrets but error on %v", output.Errors)
		}
		for _, v := range output.SecretValues {
			secret, ok := secrets[*v.Name]
			if !ok {
				continue
			}
			switch sec := secret.(type) {
			case *string:
				*sec = *v.SecretString
			case *[]byte:
				s := *v.SecretString
				*sec = []byte(s)
			default:
				if err := json.Unmarshal([]byte(*v.SecretString), secret); err != nil {
					return fmt.Errorf("unmarshal secret %q: %w", *v.Name, err)
				}
			}
		}
		hasNext = page.HasMorePages()
	}
	return nil
}
