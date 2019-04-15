resource "aws_iam_user" "exported_data_delete" {
  # We name the user assessment-export-data-delete-<workspace_name> to avoid
  # name conflicts when deploying to different workspaces
  name = "${format("assessment-export-data-delete-%s", terraform.workspace)}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_access_key" "exported_data_delete" {
  user = "${aws_iam_user.exported_data_delete.name}"
}

# IAM policy document that that allows list, get, and delete permissions on
# the export bucket.  This will be applied to the exported_data_delete role.
data "aws_iam_policy_document" "exported_data_delete_doc" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "${aws_s3_bucket.exported_data.arn}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.exported_data.arn}/*"
    ]
  }
}

# The S3 policy for our role
resource "aws_iam_user_policy" "exported_data_delete_policy" {
  user = "${aws_iam_user.exported_data_delete.name}"
  policy = "${data.aws_iam_policy_document.exported_data_delete_doc.json}"
}
