### These two has been added to secrets in this project for github actions
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
## Before Terraform Plan

```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
$ terraform plan
```