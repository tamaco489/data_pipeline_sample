# =====================================================================================
# general
# =====================================================================================
ENV      := stg
VAR_FILE := ./tfvars/${ENV}.tfvars
VAR_OPTS := -var-file "$(VAR_FILE)"


# =====================================================================================
# env variables and options
# =====================================================================================
ifeq ($(ENV),stg)
	AWS_PROFILE           := ""
	AWS_REGION            := "ap-northeast-1"
	SOPS_KMS_ARN          := "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
else ifeq ($(ENV),prd)
	AWS_PROFILE           := ""
	AWS_REGION            := "ap-northeast-1"
	SOPS_KMS_ARN          := "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
else
	AWS_PROFILE           := ""
	AWS_REGION            := "ap-northeast-1"
	SOPS_KMS_ARN          := "arn:aws:kms:ap-northeast-1:<account_id>:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
endif


# =====================================================================================
# terraform
# =====================================================================================
.PHONY: fmt init list show plan apply destroy import

fmt:
	terraform fmt

init:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) terraform init -reconfigure

list:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) terraform state list

show:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) terraform state show $(AWS_RESOURCE_TYPE).$(AWS_RESOURCE_NAME)

plan:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) terraform plan $(VAR_OPTS)

apply:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) terraform apply $(VAR_OPTS)

destroy:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) terraform destroy

remove:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) terraform state rm $(AWS_RESOURCE_TYPE).$(AWS_RESOURCE_NAME)

import:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) \
		terraform import $(AWS_RESOURCE_TYPE).$(AWS_RESOURCE_NAME) $(AWS_RESOURCE_IDENTIFIER)


# =====================================================================================
# sops
# =====================================================================================
.PHONY: encrypt-secret decrypt-secret
encrypt-secret:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) \
		sops --kms $(SOPS_KMS_ARN) tfvars/$(ENV)_$(CREDENTIAL_FILE_NAME).yaml

decrypt-secret:
	@AWS_PROFILE=$(AWS_PROFILE) AWS_DEFAULT_REGION=$(AWS_REGION) \
		sops --kms $(SOPS_KMS_ARN) -d tfvars/$(ENV)_$(CREDENTIAL_FILE_NAME).yaml
