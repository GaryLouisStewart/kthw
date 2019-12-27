# KTHW
Kubernetes the hard way (gary's way)
---

The following is a combination of resources provisioned in terraform to allow us to do kubernetes adminsitration and originally created as a helper to aid me in my studies for the CKA and CKAD certifications. I have drawn from previous experience with all of the tools used in this repository.

---
### 

I have automated most of this using a makefile to allow for very easy creates, updates, and deletion of resources. you can however view the actual code behind the scenes in each of the three folders `packer, cluster, bastion_host and the scripts folder` to gain an idea of what is going on. The following table below provides an idea of what each makefile target does

---
|Target                 |description                                   |
|-----------------------|----------------------------------------------|
| worker_ami            | Build the worker ami for kubernetes          |
| master_ami            | Build the master ami for kubernetes          |
| ssh_cleanup           | Clean up the local ssh keys and aws keypairs |
| bastion_test          | Runs a terraform plan for the bastion_host   |
| bastion_build         | Runs a terraform apply for the bastion_host  |
| bastion_destroy       | Runs a terraform destroy for the bastion_host|
| kube_test             | Runs a terraform plan for the kube cluster   |
| kube_build            | Runs a terraform apply for the kube cluster  |
| kube_destroy          | Runs a terraform destroy for the kube cluster|
---

## Here are a few examples that I have captured when running the makefile


- [ ] Make all, to print out the help for us.
- ``` make all```

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/src/common/images/make_all.png?raw=true)

- [ ] make worker_ami to build a worker-ami
- ```make worker_ami```

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/src/common/images/makefile-build-amis.png?raw=true)

- [ ] make bastion_test to run a terraform plan in the bastion_hosts directorys
- ``` make bastion_test ```

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/src/common/images/make_test_bastion.png?raw=true)
