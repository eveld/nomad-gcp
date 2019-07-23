build:
	terraform init env
	terraform apply -var-file=vars.tfvars -auto-approve env

destroy:
	terraform destroy -var-file=vars.tfvars -auto-approve env