variable "vpc_config" {
  type = object({
    name       = string
    cidr_block = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The CIDR block you entered is not valid."
  }
}

variable "subnet_config" {
  type = map(object({
    cidr_block = string
    name       = string
    public     = optional(bool, false)
    az         = optional(string)
  }))

  validation {
    condition = alltrue(
      [for config in var.subnet_config : can(cidrnetmask(config.cidr_block))]
    )
    error_message = "One or more of the CIDR blocks you entered is not valid."
  }
}