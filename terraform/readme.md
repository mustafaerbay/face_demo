### Environment Base parameters has been defined for production and if needed it could be defined later.
environment: development
environment: testing
environment: staging
environment: production
```
### These two key has been added to production environment secrets in this project for github actions
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
## For manual usage you need to export below keys or you could use aws commandline tool to configure bewlo parameters
```
aws configure 
```

```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
$ terraform plan
```

## Terraform manual deployment
Go related terraform folder for different environment (only prod-working is available)
terraform plan -out=prod_plan
terraform apply prod_plan

**NOTES:
Below variables could be needed for prod env. but for now all variables have default variables

rds_password
rds_username
rds_db_name

terraform plan -var="rds_password=mysecretpassword" -var="rds_username=postgres" -var="rds_db_name=postgres" -out=prod_plan

terraform apply prod_plan
