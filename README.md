# Overview
# Deployment diagram
# Process diagram
# architecture
* security (SGs and ACL)
* bastion/NAT
* private IPs
* ASG for web server
* ELB 
* multiple zones
* cloudwatch -> ASG

# upload template to S3

# Creating the Stack via AWS CLI

Ensure that you have the AWS CLI installed configured as per the [user guide](http://docs.aws.amazon.com/cli/latest/userguide/installing.html).

```
aws cloudformation create-stack --stack-name aftp \
    --template-body file:///path/to/aftp/cfn-templates/stack.template \
    --parameters ParameterKey=KeyName,ParameterValue=my-keyname  \
    --capabilities "CAPABILITY_IAM" 
```

# CloudTrail
In order to audit the API calls in your AWS account, CloudTrail should always be enabled.  You can use the provided CloudFormation template to enable it:

```
aws cloudformation create-stack --stack-name cloudtrail --template-body file:///path/to/aftp/cfn-templates/cloudtrail.template
```

# Creating the Stack via AWS SDK
There is a utility in [bin/manager.rb](bin/manager.rb) that creates the stack.  Before running, you'll need to have Ruby installed and run `bundle install`

```
./bin/manager.rb create -k my-keyname
```

You can then destroy the stack with:

```
./bin/manager.rb delete
```




