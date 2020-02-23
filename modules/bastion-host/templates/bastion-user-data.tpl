#!/usr/bin/env bash
# user data file for instances

# associate elastic IP address with our instance
aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${aws_eip.bastion-host.id[count.index]}