#

## usage

```bash
terraform init
terraform workspace new dev
terraform workspace select dev
terraform apply -var-file=dev.tfvars -var-file=secret.tfvars
terraform destroy -var-file=dev.tfvars -var-file=secret.tfvars
```

## tips

```bash
terraform init
terraform fmt
terraform validate
terraform show
terraform state list

terraform workspace list
terraform workspace new dev
terraform apply -var-file=dev.tfvars
terraform workspace new prod
terraform destroy -var-file=prod.tfvars
terraform workspace select dev
terraform destroy -var-file=dev.tfvars

terraform plan -out dev.out -var-file=dev.tfvars -var-file=secret.tfvars
terraform apply "dev.out"

terraform plan -destroy -out destroy.out -var-file=dev.tfvars -var-file=secret.tfvars
terraform apply "destroy.out"



```

## lint

```bash
wget https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip
unzip tflint_linux_amd64.zip && rm tflint_linux_amd64.zip
sudo mv tflint /bin/
tflint  -v
```

