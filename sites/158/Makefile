env_path=.env
include $(env_path)
export $(shell sed 's/=.*//' $(env_path))

AWS_REGION ?=ap-southeast-1
TF_STATE_S3_BUCKET ?=tf-899159155532-k3s-158
TF_STATE_DYNAMODB_TABLE=$(TF_STATE_S3_BUCKET)

.PHONY: plan
plan:
	terraform plan -var 'pm_api_url=$(PM_API_URL)' \
	-var 'pm_user=$(PM_USER)' \
	-var 'pm_password=$(PM_PASSWORD)' \
	-var 'ssh_user=$(SSH_USER)' \
	-var 'ssh_password=$(SSH_PASSWORD)'

.PHONY: apply
apply:
	terraform apply -var 'pm_api_url=$(PM_API_URL)' \
	-var 'pm_user=$(PM_USER)' \
	-var 'pm_password=$(PM_PASSWORD)' \
	-var 'ssh_user=$(SSH_USER)' \
	-var 'ssh_password=$(SSH_PASSWORD)' \
	--auto-approve

.PHONY: destroy
destroy:
	terraform destroy -var 'pm_api_url=$(PM_API_URL)' \
	-var 'pm_user=$(PM_USER)' \
	-var 'pm_password=$(PM_PASSWORD)' \
	-var 'ssh_user=$(SSH_USER)' \
	-var 'ssh_password=$(SSH_PASSWORD)' \
	--auto-approve

.PHONY: init-backend
init-backend:
	aws s3api create-bucket --bucket $(TF_STATE_S3_BUCKET) --region $(AWS_REGION) --profile $(AWS_PROFILE) \
	--acl private --create-bucket-configuration LocationConstraint=$(AWS_REGION) 2>/dev/null || true
	
	aws dynamodb create-table --table-name $(TF_STATE_DYNAMODB_TABLE) --region $(AWS_REGION) --profile $(AWS_PROFILE) \
	--key-schema AttributeName=LockID,KeyType=HASH --attribute-definitions AttributeName=LockID,AttributeType=S \
	--provisioned-throughput ReadCapacityUnits=20,WriteCapacityUnits=20 2>/dev/null || true
