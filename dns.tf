#module "internal" {
#  source          = "./modules/dns"
#  internal_domain = "mathewseby.local"
#  vpc_id          = aws_vpc.vpc.id
#}