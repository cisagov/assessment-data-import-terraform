# ------------------------------------------------------------------------------
# Configure AWS
#
# Configures AWS for use
# ------------------------------------------------------------------------------

# The AWS account ID being used
data "aws_caller_identity" "current" {}
