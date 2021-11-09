import os
import sys
import time
import requests
import urllib3

urllib3.disable_warnings()

class ControllerSetup():
    def __init__(self) -> None:
        self.url = f"https://{os.getenv('AVIATRIX_CONTROLLER_PUBLIC_IP')}/v1/api"
        self.access_account = os.getenv('ACCESS_ACCOUNT')
        self.admin_email = os.getenv('ADMIN_EMAIL')
        self.customer_id = open(os.getenv('CUSTOMER_ID_FILE_PATH'), "r").read()
        self.subscription_id = os.getenv('SUBSCRIPTION_ID')
        self.directory_id = os.getenv('DIRECTORY_ID')
        self.client_id = os.getenv('CLIENT_ID')
        self.client_secret = os.getenv('CLIENT_SECRET')
        self.controller_version = os.getenv('CONTROLLER_VERSION')
        self.controller_version_short = os.getenv('CONTROLLER_VERSION').split('-')[1][0:3]
        self.controller_username = "admin"
        self.controller_initial_password = os.getenv('AVIATRIX_CONTROLLER_PRIVATE_IP')
        self.controller_new_password = open(os.getenv('SECRET_CREDENTIAL_FILE_PATH'), "r").read()


    def _get_cid(self):
        payload = {
            'action': 'login',
            'username': self.controller_username,
            'password': ""
        }
        attempts = 5
        while attempts != 0:
            attempts -= 1
            print(f"Login attempts remaining: {attempts}")
            try:
                print("Attempting login with initial password")
                payload['password'] = self.controller_initial_password
                response = requests.post(self.url, data=payload, verify=False)
                if response.json()['return'] == True:
                    print("Successfully logged into Controller with default credentials")
                    cid = response.json()['CID']
                    return cid
                else:
                    print("Attempting login with new password")
                    payload['password'] = self.controller_new_password
                    response = requests.post(self.url, data=payload, verify=False)
                    if response.json()['return'] == True:
                        print("Successfully logged into Controller with new credentials")
                        cid = response.json()['CID']
                        return cid
                print("Sleeping for 30 seconds before trying again")
                time.sleep(30)
                continue
            except Exception as err:
                print(str(err))
                time.sleep(30)
                continue
        return False

    def _format_response(self, response):
        print("Formatting response...")
        if response.status_code == 200:
            json_body = response.json()
            print(json_body)
            return json_body
        else:
            print("Failed to return status code 200")
            print(response.status_code)
            print(response.text)
        return False

    def _is_software_up_to_date(self):
        print("Checking if software is up-to-date...")
        payload = {
            'action': 'list_version_info',
            'CID': self._get_cid()
        }
        response = requests.post(self.url, data=payload, verify=False)
        r = self._format_response(response)
        if r:
            if r.get('return') == True:
                results = r.get('results')
                print(f"Current Software Version: {results.get('current_version')}")
                print(f"Expected Software Version: {self.controller_version}")
                if results.get('current_version') == self.controller_version:
                    print("Software is up-to-date")
                    return True
                else:
                    print("Software needs to be updated")
        return False

    def set_admin_email(self):
        payload = {
            'action': 'add_admin_email_addr',
            'CID': self._get_cid(),
            'admin_email': self.admin_email
        }
        response = requests.post(self.url, data=payload, verify=False)
        r = self._format_response(response)
        if r:
            if r.get('return') == True:
                print("Successfully set admin email")
                return True
        else:
            print("Failed to set admin email")
        sys.exit(1)

    def reset_admin_password(self):
        print("Resetting Admin Password")
        payload = {
            'action': 'edit_account_user',
            'CID': self._get_cid(),
            'account_name': 'admin',
            'username': self.controller_username,
            'password': self.controller_initial_password,
            'what': 'password',
            'email': self.admin_email,
            'old_password': self.controller_initial_password,
            'new_password': self.controller_new_password
        }
        response = requests.post(self.url, data=payload, verify=False)
        r = self._format_response(response)
        if r:
            print("Successfully reset admin password")
            return
        else:
            print("Failed to reset admin password")
        sys.exit(1)

    def set_customer_id(self):
        print("Setting the customer ID.")
        payload = {
            'action': 'setup_customer_id',
            'CID': self._get_cid(),
            'customer_id': self.customer_id
        }
        response = requests.post(self.url, data=payload, verify=False)
        r = self._format_response(response)
        if r:
            print("Successfully set customer id")
            return
        else:
            print("Failed to set customer id")
        sys.exit(1)

    def onboard_azure_account(self):
        print("Onboarding Azure Account")
        payload = {
            'action': 'setup_account_profile',
            'CID': self._get_cid(),
            'cloud_type': 8,
            'account_email': self.admin_email,
            'account_name': self.access_account,
            'arm_subscription_id': self.subscription_id,
            'arm_application_endpoint': self.directory_id,
            'arm_application_client_id': self.client_id,
            'arm_application_client_secret': self.client_secret
        }
        response = requests.post(self.url, data=payload, verify=False)
        r = self._format_response(response)
        if r:
            print("Successfully added azure account")
            return
        else:
            print("Failed to add azure account")
        sys.exit(1)

    def perform_software_updates(self):
        if self._is_software_up_to_date():
            return True
        else:
            try:
                print("Attempting Software update...")
                payload = {
                    'action': 'initial_setup',
                    'CID': self._get_cid(),
                    'subaction': 'run',
                    'target_version': self.controller_version_short
                }
                response = requests.post(self.url, data=payload, verify=False, timeout=300)
                r = self._format_response(response)
                if r:
                    if r.get('return') == True:
                        print(f"Successfully updated software to: {self.controller_version}")
                        return True
                    else:
                        print("Failed to update software")
            except Exception as err:
                print(str(err))
                print('Software Upgrade API Response Timeout occurred checking if update worked.')
                attempts = 5
                while attempts != 0:
                    print(f"Attempts remaining to check software version: {attempts}")
                    attempts -= 1
                    if self._is_software_up_to_date():
                        return True
                    time.sleep(30)
                    continue
        print("All attempts to update software failed")
        sys.exit(1)

    def enable_security_group_management(self):
        print("Enabling auto security group management")
        attempts = 5
        while attempts != 0:
            print(f"Attempts remaining to enable auto security group management: {attempts}")
            attempts -= 1
            payload = {
                'action': 'enable_controller_security_group_management',
                'CID': self._get_cid(),
                'access_account_name': self.access_account
            }
            response = requests.post(self.url, data=payload, verify=False)
            r = self._format_response(response)
            if r:
                print("Successfully enabled auto security group management")
                return
            else:
                print("Failed to enabled auto security group management")
                time.sleep(30)
                continue
        sys.exit(1)


def main():
    controller = ControllerSetup()

    controller.set_admin_email()
    controller.reset_admin_password()
    controller.set_customer_id()
    controller.onboard_azure_account()
    controller.perform_software_updates()
    print("Sleeping for 60 seconds before attempting to enable security group management")
    time.sleep(60)
    controller.enable_security_group_management()

main()
sys.exit(0)