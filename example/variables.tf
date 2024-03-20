variable "name" {
  type    = string
  default = ""
}

variable "namespaces" {
  type    = any
  default = []

}

variable "user" {
  type    = string
  default = "dev"

}

variable "group" {
  type    = string
  default = "dev"
}
