output "ami_owners" {
  description = "Common AMI owners"
  value = {
    centos = "679593333241"
    redhat = "309956199498"
    amazon = "137112412989"
    ubuntu = "679593333241"
  }
}

output "ami_patterns" {
  description = "Common AMI name patterns"
  value = {
    centos7 = "CentOS Linux 7 x86_64 HVM*"
    centos6 = "CentOS Linux 6 x86_64 HVM*"
    redhat7 = "RHEL-7.6*"
    amazon  = "amzn-ami*"
    amazon2 = "amzn2-ami*"
  }
}
