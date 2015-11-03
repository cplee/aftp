# Running
aws cloudformation create-stack --stack-name aftp --template-body file:///Users/casele/Dev/sites/aftp/cfn-templates/stack.template  --parameters ParameterKey=KeyName,ParameterValue=casele-ec2  --capabilities "CAPABILITY_IAM"

# enable cloudtrail
aws cloudformation create-stack --stack-name cloudtrail --template-body file:///Users/casele/Dev/sites/aftp/cfn-templates/cloudtrail.template


# architecture
* security (SGs and ACL)
* bastion/NAT
* private IPs
* ASG for web server
* ELB 
* multiple zones
* cloudwatch -> ASG

# Deployment diagram

# Process diagram

# bootstrap script?
- download template
- run create-stack

# Manager utility
* Prerequisites - Ruby
* `bundle install`

