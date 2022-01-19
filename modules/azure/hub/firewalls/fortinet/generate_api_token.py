import paramiko
import time

sleepyTime = 0.5
receiveTime = 20000
fortigateHostname = ""
fortigateUserName = ""
fortigatePassword = ""

verbose = True

def doCommand(remote_conn,command):
    remote_conn.send(command + "\n")
    output = remote_conn.recv(receiveTime)
    if verbose:
        print(output)
    time.sleep(sleepyTime)

def generateApiToken(remote_conn):
    try:
        doCommand(remote_conn, "execute api-user generate-key test1")

    except KeyError as e:
        print(e)

def disconnectFromFG(remote_conn):
    try:
        doCommand(remote_conn,"exit")
    except KeyError as e:
        print(e)

# Connect to the Fortigate using using the paramiko and SSH
try:
    remote_init_conn = paramiko.SSHClient()
    remote_init_conn.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    remote_init_conn.connect(fortigateHostname, username=fortigateUserName, password=fortigatePassword, look_for_keys=False, allow_agent=False)
except (paramiko.ssh_exception.AuthenticationException, paramiko.ssh_exception.SSHException) as ex:
    print(f"{str(ex)}")
except paramiko.ssh_exception.NoValidConnectionsError:
    print(f"{str(ex)}")

# User list to add
# users = ["bill", "ted"]
# Connect to the VDOM
remote_conn = remote_init_conn.invoke_shell()
# Add some local users


generateApiToken(remote_conn)
# Logout
disconnectFromFG(remote_conn)