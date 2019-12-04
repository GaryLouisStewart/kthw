#!/bin/bash
# returns a list of all available images for our aws account 

if [ "$#" -lt 2 ]; then
    echo "Please Specify a region and product code to search for the desired amazon machine image "
else
    aws --region $1 ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=$2 Name=state,Values=available --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text
fi
