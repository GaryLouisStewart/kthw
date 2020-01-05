package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestKthwCluster(t *testing.T) {
	opts := &terraform.Options{
		// relative path to point at the cluster directory
		TerraformDir: "../cluster",

		// vars to pass to terraform using the -vars-file
		VarFiles: []string{"../cluster/vars/common.json"},
	}
	// wait until after tests to delete the infrastructure
	defer terraform.Destroy(t, opts)

	terraform.InitAndApply(t, opts)
}
