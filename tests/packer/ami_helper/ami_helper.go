package ami_helper

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/packer"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

var DefaultRetryablePackerErrors = map[string]string{
	"Script disconnected unexpectedly":                                                 "Occasionally, Packer seems to lose connectivity to AWS, perhaps due to a brief network outage",
	"can not open /var/lib/apt/lists/archive.ubuntu.com_ubuntu_dists_xenial_InRelease": "Occasionally, apt-get fails on ubuntu to update the cache",
}

var DefaultTimeBetweenPackerRetries = 15 * time.Second

const DefaultMaxPackerRetries = 3

var string

func testPackerAmi(t *testing.T, awsRegion string, workingDIR string, packerTemplate string) {

	awsRegion := awsRegion

	workingDir := workingDIR

	packerTemplate := packerTemplate

	test_structure.RunTestStage(t, "build_ami", func() {
		buildAmi(t, awsRegion, workingDir, packerTemplate)
	})

	defer test_structure.RunTestStage(t, "cleanup_ami", func() {
		deleteAmi(t, awsRegion, workingDir)
	})
}

func buildAmi(t *testing.T, awsRegion string, workingDir string, packerTemplate string) {
	packerOptions := &packer.Options{
		// packer template to use for testing
		Template: packerTemplate,

		Vars: map[string]string{
			"bootstrap_shell_script_path": "../../../packer/scripts/Install-Kubernetes.sh",
		},

		Only: "amazon-ebs",

		RetryableErrors:    DefaultRetryablePackerErrors,
		TimeBetweenRetries: DefaultTimeBetweenPackerRetries,
		MaxRetries:         DefaultMaxPackerRetries,
	}

	test_structure.SavePackerOptions(t, workingDir, packerOptions)

	amiId := packer.BuildAmi(t, packerOptions)

	test_structure.SaveAmiId(t, workingDir, amiId)
}

func deleteAmi(t *testing.T, awsRegion string, workingDir string) {
	amiId := test_structure.LoadAmiId(t, workingDir)

	aws.DeleteAmi(t, awsRegion, amiId)
}
