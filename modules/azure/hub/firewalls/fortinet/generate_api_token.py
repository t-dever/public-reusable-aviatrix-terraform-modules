import sys
import os
import json
import paramiko
import time
import argparse

# parser = argparse.ArgumentParser(description='A test program.')
# parser.add_argument("-fortigate_hostname", help="The fortigate ip address or hostname")
# parser.add_argument("-fortigate_username", help="The fortigate username")
# parser.add_argument("-fortigate_password", help="The fortigate password")
# args = parser.parse_args()

input = sys.stdin.read()
input_json = json.loads(input)

fortigate_hostname = input_json['fortigate_hostname']
fortigate_username = input_json['fortigate_username']
fortigate_password = input_json['fortigate_password']
# print(args.fortigate_hostname)
# print(args.fortigate_username)
# print(args.fortigate_password)
sleepyTime = 0.5
receiveTime = 100000
# fortigateHostname = os.getenv('FORTIGATE_HOSTNAME')
# fortigateUserName = os.getenv('FORTIGATE_USERNAME')
# fortigatePassword = os.getenv('FORTIGATE_PASSWORD')

verbose = True

# def doCommand(remote_conn,command):
#     remote_conn.send(command + "\n")
#     output = remote_conn.recv(receiveTime)
#     if verbose:
#         print(output)
    # time.sleep(sleepyTime)

def generateApiToken(remote_conn):
    try:
        remote_conn.send("execute api-user generate-key test1"+ "\n")
        # doCommand(remote_conn, "execute api-user generate-key test1")
        time.sleep(sleepyTime)
        output = remote_conn.recv(receiveTime)
        # time.sleep(sleepyTime)
        if output:
            decode_output = output.decode("utf-8")
            formatted_output = decode_output.splitlines()
            # api_key = formatted_output[3].split()[-1]
            api_key = {
                "api_key": formatted_output[3].split()[-1]
            }
            json_key = json.dumps(api_key, indent=4)
            print(json_key)
            return api_key
    except KeyError as e:
        error = {"error": str(e)}
        json.dumps(error, indent=4)

def disconnectFromFG(remote_conn):
    try:
        remote_conn.send("exit"+ "\n")
        # doCommand(remote_conn,"exit")
    except KeyError as e:
        error = {"error": str(e)}
        json.dumps(error, indent=4)

# Connect to the Fortigate using using the paramiko and SSH
try:
    remote_init_conn = paramiko.SSHClient()
    remote_init_conn.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    remote_init_conn.connect(fortigate_hostname, username=fortigate_username, password=fortigate_password, look_for_keys=False, allow_agent=False)
except (paramiko.ssh_exception.AuthenticationException, paramiko.ssh_exception.SSHException) as ex:
        error = {"error": str(ex)}
        json.dumps(error, indent=4)
except paramiko.ssh_exception.NoValidConnectionsError:
        error = {"error": str(ex)}
        json.dumps(error, indent=4)

# User list to add
# users = ["bill", "ted"]
# Connect to the VDOM
remote_conn = remote_init_conn.invoke_shell()
# Add some local users

generateApiToken(remote_conn)

# Logout
disconnectFromFG(remote_conn)