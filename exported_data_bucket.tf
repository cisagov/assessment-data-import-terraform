# This bucket is used to store a JSON file containing all exported
# assessment data to be imported into the CyHy database.
resource "aws_s3_bucket" "exported_data" {
  # Note that in production Terraform workspaces, the string '-production' is
  # appended to the bucket name.  In non-production workspaces,
  # '-<workspace_name>' is appended to the bucket name.
  bucket = format("%s-%s", var.assessment_data_s3_bucket, local.production_workspace ? "production" : terraform.workspace)

  tags = {
    "Name" = "Exported Assessment Data"
  }

  lifecycle {
    ignore_changes = [
      # This should be removed when we upgrade the Terraform AWS provider to
      # v4. It is necessary to use with the backported resources in v3.75 to
      # avoid conflicts/unexpected apply results.
      server_side_encryption_configuration,
    ]
    prevent_destroy = true
  }
}

# Ensure the S3 bucket is encrypted
resource "aws_s3_bucket_server_side_encryption_configuration" "exported_data" {
  bucket = aws_s3_bucket.exported_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# This blocks ANY public access to the bucket or the objects it
# contains, even if misconfigured to allow public access.
resource "aws_s3_bucket_public_access_block" "exported_data" {
  bucket = aws_s3_bucket.exported_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Any objects placed into this bucket should be owned by the bucket
# owner. This ensures that even if objects are added by a different
# account, the bucket-owning account retains full control over the
# objects stored in this bucket.
resource "aws_s3_bucket_ownership_controls" "exported_data" {
  bucket = aws_s3_bucket.exported_data.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
