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

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = "Assessment Data Import Lambda"
    },
  )

  lifecycle {
    prevent_destroy = true
  }
}
