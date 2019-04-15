resource "aws_s3_bucket" "exported_data" {
  # This bucket is used to store a JSON file containing all exported
  # assessment data to be imported into our AWS database
  bucket = "${format("assessment-export-data-%s", terraform.workspace)}"

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
