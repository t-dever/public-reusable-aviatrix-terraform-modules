import json
import os
import socket
import sys
import time

from paramiko import AutoAddPolicy, SSHClient, ssh_exception

sleepyTime = 5
receiveTime = 100000

class PaloAlto():

    def __init__(self):
        self.host_ip = os.getenv('PALO_IP_ADDRESS')
        self.username = os.getenv('PALO_USERNAME')
        self.new_password = os.getenv('PALO_NEW_PASSWORD')
        self.private_key_file_location = os.getenv('PALO_PRIVATE_KEY_LOCATION')
        self.connection = self.connect()

    def connect(self):
        print(f"Starting Connection Attempt.")
        attempts = 10
        while attempts != 0:
            print(f"Remaining Attempts: {attempts}")
            attempts -= 1
            try:
                remote_init_conn = SSHClient()
                remote_init_conn.load_system_host_keys()
                remote_init_conn.set_missing_host_key_policy(AutoAddPolicy())
                # This will attempt to look on the local machine for the private ssh key
                remote_init_conn.connect(self.host_ip, username=self.username, key_filename=self.private_key_file_location)
                remote_con = remote_init_conn.invoke_shell()
                print(f"Successfully Connected to: {self.host_ip}")
                return remote_con
            except ssh_exception.AuthenticationException as err:
                print("An Authentication Error has occurred.")
                print(f"{str(err)}")
            except socket.error as err:
                print(f"Socket Error occurred: {str(err)}")
                time.sleep(60)
                if attempts == 0:
                    print(json.dumps(error, indent=4))
                else:
                    print(str(err))
                    continue
            except Exception as err:
                time.sleep(60)
                if attempts == 0:
                    error = {"error": str(err)}
                    print(json.dumps(error, indent=4))
                else:
                    print(str(err))
                    continue
        else:
            print("All attempts failed to connect failed.")
            sys.exit(1)

    def set_admin_password(self):
        attempts = 2
        while attempts != 0:
            attempts -= 1
            try:
                commands_list = [
                    "configure" ,
                    f"set mgt-config users {self.username} password",
                    self.new_password,
                    self.new_password,
                    "commit"
                ]
                print("Configuring password")
                for command in commands_list:
                    time.sleep(5)
                    self.connection.send(command + "\n")
                    output = self.connection.recv(receiveTime)
                    print(output.decode())
                return
            except socket.error as err:
                print(f"Socket Error occurred: {str(err)}")
                time.sleep(60)
                if attempts == 0:
                    print(json.dumps(err, indent=4))
                    sys.exit(1)
                else:
                    self.connect()
                    print(str(err))
                    continue
            except KeyError as err:
                error = {"error": str(err)}
                json.dumps(error, indent=4)
                sys.exit(1)

    def disconnect(self):
        try:
            self.connection.close()
        finally:
            if self.connection:
                self.connection.close()


def main():
    connection = PaloAlto()
    connection.set_admin_password()
    connection.disconnect()

main()
sys.exit(0)
