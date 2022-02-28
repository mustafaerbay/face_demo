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