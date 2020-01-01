# Bastion host Documentation

### The following resources are created as part of the terraform process.


---
| Resource                    | Description                                         |Provider|
| ----------------------      |-------------------------                            |--------|
| VPC                         | The default K8s VPC                                 | aws    |
| EC2 Instance (Bastion host) | The default EC2 bastion host server                 | aws    |
| Security group              | bastion host security group egress [0.0.0.0/0] only | aws    |
| SG-rule secure              | optional (ingress traffic bastion host) only        | aws    |
| SG-rule insecure            | optional (insecure traffic into bastion host) only  | aws    |

--- 
### The following is a description of each command along with examples of how to provision the infrastructure using terraform. 
---


- [ ] Terraform init, Intializes a directory, downloads all relative plugins, files and packages needed by terraform and checks/setsup credentials with our provider AWS.
- `../scripts/tf_actions.sh -i`

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/bastion_host/src/common/images/tf_init.png?raw=true)



- [ ] Terraform Plan using our script. runs a terraform plan and logs it to the ./logs directory of your relative path.

    `../scripts/tf_action.sh -p `

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/bastion_host/src/common/images/tf_plan.png?raw=true)

- [ ] Terraform Apply, Intializes a directory, applies the planned terraform configuration to our AWS account.
- `./scripts/tf_actions.sh -a`

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/bastion_host/src/common/images/tf_apply.png?raw=true)



- [ ] Terraform Destroy runs a terraform pdestroy removing all resources from the given account.

    `../scripts/tf_action.sh -d `

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/bastion_host/src/common/images/tf_destroy.png?raw=true)

-----

### Example resource creation

- [ ] An Example resource creation using terraform
  ```
  ../scripts/tf_action.sh -p
  ../scripts/tf_action.sh -a
  ```
![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/bastion_host/src/common/images/example-resource-creation.png?raw=true)
