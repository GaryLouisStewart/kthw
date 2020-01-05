# Packer AMI Tests

Basic tests for our AMI, e.g. does it build correctly, optional parameters to specify variables to override in the templates can be passed into the functions like below..

```
Vars: map[string]string{
			"bootstrap_shell_script_path": "../../../packer/scripts/Install-Kubernetes.sh",
		},
```
so you can define an additional variable like above and override what is set in the template file which is useful for testing. 

another thing to take into account is the keys that you need to generate in order to allow packer to ssh to the temporary EC2 instance that is used for image building. The following command below will help with this.

```
../../../packer/gen_keys.sh -g <key-name>
# generate the keys that we need in local DIR and uploads them as a keypair to AWS

../../../packer/gen_keys.sh -d <key-name>
# deletes keypair from AWS and removes it from local DIR
```
