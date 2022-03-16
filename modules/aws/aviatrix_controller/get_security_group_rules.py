import sys
import boto3
import json
from botocore.config import Config

input = sys.stdin.read()
input_json = json.loads(input)

region = input_json['region']
vpc_id = input_json['vpc_id']

my_config = Config(
    region_name = region,
    signature_version = 'v4',
    retries = {
        'max_attempts': 10,
        'mode': 'standard'
    }
)

def get_security_groups(ec2):
    security_groups = ec2.describe_security_groups(
        Filters=[
            {
                'Name': 'tag:Name', 
                'Values':['AviatrixSecurityGroup']
            },
            {
                'Name': 'vpc-id', 
                'Values':[vpc_id]
            }])
    return security_groups

def get_ingress_ip_cidrs(security_group):
    cidr_list = []
    if security_group.get('IpPermissions'):
        for rule in security_group.get('IpPermissions'):
            if rule.get('IpRanges'):
                for cidr in rule.get('IpRanges'):
                    cidr_list.append(cidr['CidrIp'])
    return cidr_list

ec2 = boto3.client('ec2', config=my_config)
security_groups = get_security_groups(ec2)

compiled_cidr_list = []
for group in security_groups['SecurityGroups']:
    compiled_cidr_list.extend(get_ingress_ip_cidrs(group))

json_output = {
    "gateway_cidrs": json.dumps(compiled_cidr_list, separators=(',', ':'))
    }

json_output_formatted = json.dumps(json_output, indent=4)
print(json_output_formatted)
