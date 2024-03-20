module "role" {
  source = "../"

  namespaces = ["dev", "default"]
  user       = "dev"
  group      = "dev"
}
