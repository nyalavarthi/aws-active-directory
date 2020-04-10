<h2> This repo Creates MicrosoftAD standard edition</h2>
Following resources will be created by the repo :
<ul>
    <li>aws_directory_service_directory</li>
    <li>aws_vpc_dhcp_options</li>
    <li>aws_vpc_dhcp_options_association </li>
    <li>aws_ssm_document </li>
    <li>aws_ssm_document </li>
    <li>random_string</li>
    <li>aws_ssm_parameter </li>
    
</ul>
terraform workspaces is impemented for this repo, refer to the variables.tf for env specific values. 

<p>
Terraform commands to run & apply the changes.

```
#initialize workspace
terraform init -backend-config=backends/dev-env.tf

#create / change workspace
terraform workspace new "dev"
#terraform workspace select "dev"

#plan and apply
terraform plan
terraform apply

```
