import sys
import json
import paramiko
import time

input = sys.stdin.read()
input_json = json.loads(input)

fortigate_hostname = input_json['fortigate_hostname']
fortigate_username = input_json['fortigate_username']
fortigate_password = input_json['fortigate_password']

sleepyTime = 0.5
receiveTime = 100000


def generateApiToken(remote_conn):
    try:
        remote_conn.send("execute api-user generate-key test1"+ "\n")
        time.sleep(sleepyTime)
        output = remote_conn.recv(receiveTime)
        if output:
            decode_output = output.decode("utf-8")
            formatted_output = decode_output.splitlines()
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
    except KeyError as e:
        error = {"error": str(e)}
        print(json.dumps(error, indent=4))

# Connect to the Fortigate using using the paramiko and SSH
try:
    remote_init_conn = paramiko.SSHClient()
    remote_init_conn.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    remote_init_conn.connect(fortigate_hostname, username=fortigate_username, password=fortigate_password, look_for_keys=False, allow_agent=False)
except (paramiko.ssh_exception.AuthenticationException, paramiko.ssh_exception.SSHException) as ex:
        error = {"error": str(ex)}
        print(json.dumps(error, indent=4))
except paramiko.ssh_exception.NoValidConnectionsError:
        error = {"error": str(ex)}
        print(json.dumps(error, indent=4))

remote_conn = remote_init_conn.invoke_shell()

# Generate API Token
generateApiToken(remote_conn)

# Logout
disconnectFromFG(remote_conn)