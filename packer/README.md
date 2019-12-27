# Packer build documentation

### The following amis are created as part of this process...


---
|AMI                    |Tooling (e.g. k8s, docker)          |OS (e.g. ubuntu)
|-----------------------|------------------------------------|--------------------
|Kubrenetes-worker-node | k8s, docker                        | Ubuntu Xenial 16.04
|kubernetes-master-node | k8s, docker                        | Ubuntu Xenial 16.04

---

The following is a wiki of all the different commands that can be run from within the `packer` directory make sure that you have gone into ```cd packer``` from the top level directory when you are attempting to run any commands starting with `./build.sh` otherwise they will not work. This builds an `ubuntu xenial 16.04` amazon machine image that can be used with your AWS account.


---

### A description of each one of the commands that can be run as well as a screenshot with the given example

- [ ] AWS-CLI Command used to search for the ubuntu AMI, filtering with the owner-id and product code
- ``` aws ec2 describe-images --owners 099720109477  --filters 'Name=name,Values="d83d0782-cb94-46d7-8993-f4ce15d1a484"' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text```
---

- [ ] Builds an AMI image for our worker nodes
- ```./build.sh -b worker```
  
![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/packer/src/common/images/packer-build-worker.png?raw=true)


- [ ] Builds an AMI image for our master nodes
- ```./build.sh -b master ```

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/packer/src/common/images/packer-build-master.png?raw=true)

- [ ] Concurrent builds
- ```./build.sh -b master && ./build.sh -b worker```

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/packer/src/common/images/packer-concurrent-builds.png?raw=true)


- [ ] Provisioners executing on AMI build

![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/packer/src/common/images/packer_provisioners.png?raw=true)

- [ ] Finished builds, what you should see at the end of a sucessfull build
  
![alt text](https://github.com/GaryLouisStewart/kthw/blob/master/packer/src/common/images/packer-sucessfull-build.png?raw=true)