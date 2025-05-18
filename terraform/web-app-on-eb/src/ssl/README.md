## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.client_ssl_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.server_ssl_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_lb_listener.back_end](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_route53_record.client_dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.server_dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.product_infra](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_domain_name"></a> [client\_domain\_name](#input\_client\_domain\_name) | Client Domain Name | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | The tags to be associated with IAC provisioned resources | `map(string)` | <pre>{<br/>  "product:costCenter": "<Product-Name>",<br/>  "product:owner": "<Product-Name>",<br/>  "product:role": "Web"<br/>}</pre> | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name | `string` | n/a | yes |
| <a name="input_remote-state-backend-bucket-name"></a> [remote-state-backend-bucket-name](#input\_remote-state-backend-bucket-name) | The name of bucket that stores terraform state of provisioned resources | `string` | n/a | yes |
| <a name="input_server_domain_name"></a> [server\_domain\_name](#input\_server\_domain\_name) | Server Domain Name | `string` | n/a | yes |

## Outputs

No outputs.
