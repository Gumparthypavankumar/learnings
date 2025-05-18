name = "Example Cluster"

# -----------------------------------------
# Network Variables
# -----------------------------------------

vpc-name     = "vpc-demo-dev"
cidr-address = "10.1.0.0/24"

public-subnets      = ["10.1.0.128/27", "10.1.0.160/27"]
private-subnets     = ["10.1.0.0/26", "10.1.0.64/26"]
persistence-subnets = ["10.1.0.192/27", "10.1.0.224/27"]

vpc-availability-zones = ["us-east-1a", "us-east-1b"]

public-subnets-names      = ["public-subnet-us-east-1a", "public-subnet-us-east-1b"]
private-subnets-names     = ["private-subnet-us-east-1a", "private-subnet-us-east-1b"]
persistence-subnets-names = ["persistence-subnet-us-east-1a", "persistence-subnet-us-east-1b"]

# ---------------------------------------------
# Application Variables
# ---------------------------------------------
eb_description                    = "The Demo environment"
eb_application_name               = "eb-dev-demo"
eb_environment_type               = "LoadBalanced"
eb_loadbalancer_type              = "application"
eb_loadbalancer_crosszone_enabled = false
eb_instance_type                  = "t2.micro"
eb_health_check_url               = "/"

# ---------------------------------------------
# Storage Variables
# ---------------------------------------------
db_instance_class      = "db.t4g.micro"
db_provisioned_storage = 20
db_initial_name        = "demo"
db_master_user_name    = "demodevmasteruser"