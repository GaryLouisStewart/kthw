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

In order to get the tests to run you will need to run the following commands first of all.... 

```
# for the worker 
cd worker_tests
go mod init packer_worker_test.go
go test -v

# for the master nodes
cd master_tests
go mod init packer_master_test.go
go test -v
```

You will also notice in the directory a file called go.mod which will include a file with a similar layout to below.

# Typical contents of the go-module file

```
module packer_worker_test.go

go 1.13

require (
	github.com/aws/aws-sdk-go v1.27.0
	github.com/gruntwork-io/terratest v0.23.0
)
```

This will be automatically generated after the go mod init commnad has been run, then once go test -v is run it will automaticall look at this file and dependencies within the package and start downloading them.