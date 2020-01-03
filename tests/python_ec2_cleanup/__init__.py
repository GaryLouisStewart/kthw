import boto3
import logging
from botocore.exceptions import ClientError

def list_instance_by_tag_value(tagkey, tagvalue):
    """
    param tagkey is the selected field under tag that we will filter by e.g. 'Name'
    param tagvalue is the value of the tagkey that we are choosing to filter by e.g. 'my-ec2-instance'
    :return: A list of all the instance ids that correspond with the tagkey and value
    """

    ec2_client = boto3.client('ec2')

    response = ec2_client.describe_instances(
        Filters=[
            {
            'Name': 'tag:'+tagkey,
            'Values': [tagvalue]   
            }
        ]
    )

    instancelist = []

    try:
        for reservation in (response["Reservations"]):
            for instance in reservation["Instances"]:
                instancelist.append(instance["InstanceId"])
        return instancelist

    except ClientError as e:
        logging.error(e)
        return None
    return instancelist


def terminate_ec2_instances(ec2_instance_ids):
    '''
    param ec2_instance_ids, a list of one or more ec2 instance id's that will be terminated
    :return: a List of state information for each instance specified
    '''

    ec2 = boto3.client('ec2')

    try:
        states = ec2.terminate_instances(InstanceIds=ec2_instance_ids)
    except ClientError as e:
        logging.error(e)
        return None
    return states['TerminatingInstances']


def execute_ec2_removal(instance_id_list):
    """
    param: instance_id_list, pass a list of instance ids over to our function in order to terminate them.
    execute terminate_ec2_instances()
    """

    ec2_instance_ids = instance_id_list

    logging.basicConfig(level=logging.DEBUG,
                        format='%(levelname)s: %(asctime)s: %(message)s')
    states = terminate_ec2_instances(ec2_instance_ids)

    if states is not None:
        logging.debug('Terminating the following EC2 instances')
        for state in states:
            logging.debug(f'ID: {state["InstanceId"]}')
            logging.debug(f'  Current State: Code {state["CurrentState"]["Code"]},'
                        f'{state["CurrentState"]["Name"]}')
            logging.debug(f'  Previous state: Code {state["PreviousState"]["Code"]},'
                        f'{state["PreviousState"]["Name"]}')
