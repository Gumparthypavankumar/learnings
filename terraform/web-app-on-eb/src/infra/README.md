## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cdn"></a> [cdn](#module\_cdn) | terraform-aws-modules/cloudfront/aws | >= 4.1 |
| <a name="module_database"></a> [database](#module\_database) | terraform-aws-modules/rds/aws | ~> 6.12 |
| <a name="module_eb_application"></a> [eb\_application](#module\_eb\_application) | cloudposse/elastic-beanstalk-application/aws | n/a |
| <a name="module_eb_environment"></a> [eb\_environment](#module\_eb\_environment) | cloudposse/elastic-beanstalk-environment/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.s3-object-store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3-static-site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_cdn_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3-object-store-access-policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.s3-static-site-access-policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3-object-store-encryption-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3-static-site-encryption-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eb_elb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.allow_eb_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_eb_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [random_string.bucket_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.allow_cdn_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_cidr-address"></a> [cidr-address](#input\_cidr-address) | n/a | `string` | n/a | yes |
| <a name="input_db_initial_name"></a> [db\_initial\_name](#input\_db\_initial\_name) | The initial database to create once provisioned | `string` | `"sample"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | -------------------------------- Storage Variables -------------------------------- | `string` | `"db.t4g.micro"` | no |
| <a name="input_db_master_password"></a> [db\_master\_password](#input\_db\_master\_password) | The master password | `string` | n/a | yes |
| <a name="input_db_master_user_name"></a> [db\_master\_user\_name](#input\_db\_master\_user\_name) | The master username | `string` | n/a | yes |
| <a name="input_db_provisioned_storage"></a> [db\_provisioned\_storage](#input\_db\_provisioned\_storage) | n/a | `number` | `20` | no |
| <a name="input_eb_application_name"></a> [eb\_application\_name](#input\_eb\_application\_name) | n/a | `string` | n/a | yes |
| <a name="input_eb_application_stack"></a> [eb\_application\_stack](#input\_eb\_application\_stack) | n/a | `string` | `"64bit Amazon Linux 2023 v4.6.1 running PHP 8.2"` | no |
| <a name="input_eb_description"></a> [eb\_description](#input\_eb\_description) | ----------------------------------- Application Variables ----------------------------------- | `string` | n/a | yes |
| <a name="input_eb_environment_type"></a> [eb\_environment\_type](#input\_eb\_environment\_type) | n/a | `string` | n/a | yes |
| <a name="input_eb_health_check_url"></a> [eb\_health\_check\_url](#input\_eb\_health\_check\_url) | n/a | `string` | `"/"` | no |
| <a name="input_eb_instance_type"></a> [eb\_instance\_type](#input\_eb\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_eb_loadbalancer_crosszone_enabled"></a> [eb\_loadbalancer\_crosszone\_enabled](#input\_eb\_loadbalancer\_crosszone\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_eb_loadbalancer_type"></a> [eb\_loadbalancer\_type](#input\_eb\_loadbalancer\_type) | n/a | `string` | n/a | yes |
| <a name="input_instance_key_pair_name"></a> [instance\_key\_pair\_name](#input\_instance\_key\_pair\_name) | Provide the key pair name which is already available in same region where the resources are provisioned | `string` | n/a | yes |
| <a name="input_persistence-subnets"></a> [persistence-subnets](#input\_persistence-subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_persistence-subnets-names"></a> [persistence-subnets-names](#input\_persistence-subnets-names) | n/a | `list(string)` | n/a | yes |
| <a name="input_private-subnets"></a> [private-subnets](#input\_private-subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_private-subnets-names"></a> [private-subnets-names](#input\_private-subnets-names) | n/a | `list(string)` | n/a | yes |
| <a name="input_public-subnets"></a> [public-subnets](#input\_public-subnets) | n/a | `list(string)` | n/a | yes |
| <a name="input_public-subnets-names"></a> [public-subnets-names](#input\_public-subnets-names) | n/a | `list(string)` | n/a | yes |
| <a name="input_remote-state-backend-bucket-name"></a> [remote-state-backend-bucket-name](#input\_remote-state-backend-bucket-name) | The name of bucket that will store terraform states | `string` | n/a | yes |
| <a name="input_vpc-availability-zones"></a> [vpc-availability-zones](#input\_vpc-availability-zones) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc-name"></a> [vpc-name](#input\_vpc-name) | -------------------------------- Network Variables -------------------------------- | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb-arn"></a> [alb-arn](#output\_alb-arn) | The ARN of ALB |
| <a name="output_cloudfront-distribution-id"></a> [cloudfront-distribution-id](#output\_cloudfront-distribution-id) | The Distribution ID of Cloudfront |
| <a name="output_db-endpoint"></a> [db-endpoint](#output\_db-endpoint) | The DB endpoint |
| <a name="output_s3-object-store"></a> [s3-object-store](#output\_s3-object-store) | The Bucket name of S3 Object Store |
| <a name="output_s3-static-site"></a> [s3-static-site](#output\_s3-static-site) | The Bucket name of S3 Client App |
| <a name="output_vpc-id"></a> [vpc-id](#output\_vpc-id) | The ID of the VPC |
