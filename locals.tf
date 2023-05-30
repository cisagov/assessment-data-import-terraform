locals {
  # Determine if this is a Production workspace by checking
  # if terraform.workspace begins with "prod"
  production_workspace = length(regexall("^prod", terraform.workspace)) == 1
}
