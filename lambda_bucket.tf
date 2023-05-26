resource "aws_s3_bucket" "adi_lambda" {
  # This bucket is used to store the lambda function that imports assessment
  # data from the exported_data bucket into the CyHy database.
  # Note that in production terraform workspaces, the string '-production' is
  # appended to the bucket name.  In non-production workspaces,
  # '-<workspace_name>' is appended to the bucket name.
  bucket = local.production_workspace ? format("%s-production", var.assessment_data_import_lambda_s3_bucket) : format(
    "%s-%s",
    var.assessment_data_import_lambda_s3_bucket,
    terraform.workspace,
  )

  tags = {
    "Name" = "Assessment Data Import Lambda"
  }

  lifecycle {
    ignore_changes = [
      # This should be removed when we upgrade the Terraform AWS provider to
      # v4. It is necessary to use with the back-ported resources in v3.75 to
      # avoid conflicts/unexpected apply results.
      server_side_encryption_configuration,
    ]
    prevent_destroy = true
  }
}

# Ensure the S3 bucket is encrypted
resource "aws_s3_bucket_server_side_encryption_configuration" "adi_lambda" {
  bucket = aws_s3_bucket.adi_lambda.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
