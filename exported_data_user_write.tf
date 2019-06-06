resource "aws_iam_user" "exported_data_write" {
  # We name the user based on the bucket name (which is based on the
  # terraform workspace name) to avoid name conflicts when deploying to
  # different workspaces
  name = format("%s-write", aws_s3_bucket.exported_data.id)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_access_key" "exported_data_write" {
  user = aws_iam_user.exported_data_write.name
}

# IAM policy document that that allows write permissions on the export
# bucket.  This will be applied to the exported_data_write role.
data "aws_iam_policy_document" "exported_data_write_doc" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.exported_data.arn}/*",
    ]
  }
}

# The S3 policy for our role
resource "aws_iam_user_policy" "exported_data_write_policy" {
  user   = aws_iam_user.exported_data_write.name
  policy = data.aws_iam_policy_document.exported_data_write_doc.json
}
