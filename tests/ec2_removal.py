from python_ec2_cleanup import list_instance_by_tag_value
from python_ec2_cleanup import terminate_ec2_instances
from python_ec2_cleanup import execute_ec2_removal



# Instances_to_terminate_1 = list_instance_by_tag_value("Name", "Kubernetes Worker Node-0")
# Instances_to_terminate_2 = list_instance_by_tag_value("Name", "Kubernetes Worker Node-1")
# Instances_to_terminate_3 = list_instance_by_tag_value("Name", "Kubernetes Master Node-0")
# print(execute_ec2_removal(Instances_to_terminate_1))
# print(execute_ec2_removal(Instances_to_terminate_2))
# print(execute_ec2_removal(Instances_to_terminate_3))
