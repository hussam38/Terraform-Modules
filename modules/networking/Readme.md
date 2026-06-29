A networking module that should:

1- [Done] A VPC with a given CIDR block
2- [Done] Allow the user to provide the configuration for multiple subnets:
  2.1 [Done] The user should be able to provide CIDR blocks
  2.2 [Done] The user should be able to provide AWS AZ
  2.3 [Done] The user should be able to mark a subnet as public or private
    2.3.1 [Done] If at least one subnet is public, we need to deploy an IGW
    2.3.2 [Done] We need to associate the public subnets with a public RTB
