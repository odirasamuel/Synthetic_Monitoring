provider "aws" {
  alias = "east"
  region  = "us-gov-east-1"
  profile = "feddev"
}

provider "aws" {
  alias = "west"
  region  = "us-gov-west-1"
  profile = "feddev"
}