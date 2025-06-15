resource "aws_kms_key" "this" {
  description             = "kms key for sops encryption"
  enable_key_rotation     = true # Enable key rotation
  rotation_period_in_days = 90   # Key rotation period
  deletion_window_in_days = 7    # Deletion grace period
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.env}/${var.project}/sops"
  target_key_id = aws_kms_key.this.key_id
}
