resource "aws_s3_bucket" "exported_data" {
  # This bucket is used to store a JSON file containing all exported
  # assessment data to be imported into our AWS database.
  # Note that in production terraform workspaces, the string '-production' is
  # appended to the bucket name.  In non-production workspaces,
  # '-<workspace_name>' is appended to the bucket name.
  bucket = "${local.production_workspace ? format("%s-production", var.assessment_data_s3_bucket) : format("%s-%s", var.assessment_data_s3_bucket, terraform.workspace)}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${merge(var.tags, map("Name", "Exported Assessment Data"))}"

  lifecycle {
    prevent_destroy = true
  }
}
