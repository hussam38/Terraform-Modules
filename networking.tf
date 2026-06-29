module "networking" {
  source = "./modules/networking"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "main-vpc"
  }

  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.1.0/24"
      name       = "subnet1"
      public     = true
      az         = "us-east-1a"
    }
    subnet_2 = {
      cidr_block = "10.0.2.0/24"
      name       = "subnet2"
      public     = false
      az         = "us-east-1b"
    }
    subnet_3 = {
      cidr_block = "10.0.3.0/24"
      name       = "subnet3"
      public     = true
      az         = "us-east-1c"
    }
  }
}