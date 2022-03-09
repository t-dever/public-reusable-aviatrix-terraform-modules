import os
import sys
import time
import requests
import urllib3

urllib3.disable_warnings()


class ControllerSetup():
    def __init__(self) -> None:
        self.url = (
            f"https://{os.getenv('AVIATRIX_CONTROLLER_PUBLIC_IP')}/v1/api")
        self.admin_email = os.getenv('ADMIN_EMAIL')
        self.customer_id = os.getenv('CUSTOMER_ID')
        self.controller_version = os.getenv('CONTROLLER_VERSION')
        self.controller_username = "admin"
        self.controller_initial_password = os.getenv(
            'AVIATRIX_CONTROLLER_PRIVATE_IP')
        self.controller_new_password = os.getenv(
            'AVIATRIX_CONTROLLER_PASSWORD')
        self.primary_access_account = ""

    def _check_environment_vars(self):
        print("Checking required environment variables.")
        required_environment_vars = [
            "ADMIN_EMAIL",
            "CUSTOMER_ID",
            "CONTROLLER_VERSION",
            "AVIATRIX_CONTROLLER_PUBLIC_IP",
            "AVIATRIX_CONTROLLER_PRIVATE_IP",
            "AVIATRIX_CONTROLLER_PASSWORD"
        ]
        failed_to_find_list = []
        for env in required_environment_vars:
            if not os.getenv(env):
                failed_to_find_list.append(env)
                print(f"Failed to find environment variable: '{env}'")
        if failed_to_find_list:
            print(f"Failed to find the following environment variables: "
                  f"{failed_to_find_list}")
            sys.exit(1)
        else:
            print("All required environment variables are set.")

    def _get_cid(self):
        payload = {
            'action': 'login',
            'username': self.controller_username,
            'password': ""
        }
        attempts = 10
        while attempts != 0:
            attempts -= 1
            print(f"Login attempts remaining: {attempts}")
            try:
                print("Attempting login with initial password")
                payload['password'] = self.controller_initial_password
                response = requests.post(self.url, data=payload, verify=False)
                if response.json()['return'] is True:
                    print("Successfully logged into Controller with default"
                          " credentials")
                    cid = response.json()['CID']
                    return cid
                else:
                    print("Attempting login with new password")
                    payload['password'] = self.controller_new_password
                    response = requests.post(self.url, data=payload,
                                             verify=False)
                    if response.json()['return'] is True:
                        print("Successfully logged into Controller with new"
                              " credentials")
                        cid = response.json()['CID']
                        return cid
                print("Sleeping for 30 seconds before trying again")
                time.sleep(30)
                continue
            except Exception as err:
                print(str(err))
                time.sleep(30)
                continue
        raise Exception

    def _format_response(self, response):
        print("Formatting response...")
        if response.status_code == 200:
            results = response.json()
            print(f"JSON BODY: {results}")
            return results
            # if results.get('return') is True:
        print("Failed to return status code 200")
        print(response.status_code)
        print(response.text)
        raise Exception

    def _is_software_up_to_date(self, controller_version):
        print("Checking if software is up-to-date...")
        payload = {
            'action': 'list_version_info',
            'CID': self._get_cid()
        }
        response = self._format_response(
            requests.post(self.url, data=payload, verify=False))
        results = response.get('results')
        current_version_short = (
            results.get('current_version').split('-')[1][0:3])
        print(f"Current Software Version: {current_version_short}")
        print(f"Expected Software Version: {controller_version}")
        if current_version_short == controller_version:
            print("Software is up-to-date")
            return True
        else:
            print("Software needs to be updated")
            return False

    def _does_account_exist(self, account_name):
        check_payload = {
            'action': 'list_accounts',
            'CID': self._get_cid()
        }
        response = self._format_response(
            requests.post(self.url, data=check_payload, verify=False))
        account_list = response['results']['account_list']
        for account in account_list:
            if account['account_name'] == account_name:
                print(f"Found account {account_name}.")
                return True
            else:
                pass
        return False

    def set_admin_email(self):
        print("Attempting to set admin email.")
        payload = {
            'action': 'add_admin_email_addr',
            'CID': self._get_cid(),
            'admin_email': self.admin_email
        }
        self._format_response(
            requests.post(self.url, data=payload, verify=False))
        print("Successfully set admin email.")

    def reset_admin_password(self):
        print("Resetting admin password.")
        initial_login = {
            'action': 'login',
            'username': self.controller_username,
            'password': self.controller_initial_password
        }
        initial_response = self._format_response(requests.post(
            self.url, data=initial_login, verify=False))
        print("Checking if credential is using initial password.")
        if initial_response.get('return') is True:
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
            response = self._format_response(
                requests.post(self.url, data=payload, verify=False))
            if response.get('return') is True:
                print("Successfully reset admin password.")
                return
            else:
                raise Exception("Initial Password Reset Failed.")
        else:
            print("Credential is up to date.")

    def set_customer_id(self):
        print("Attempting to set customer id.")
        payload = {
            'action': 'setup_customer_id',
            'CID': self._get_cid(),
            'customer_id': self.customer_id
        }
        self._format_response(
            requests.post(self.url, data=payload, verify=False))
        print("Successfully set customer id")

    def software_update(self, controller_version, initial_upgrade=True):
        try:
            if initial_upgrade:
                print("Attempting Initial Software Update...")
                print(
                    f"Attempting to upgrade software to {controller_version}")
                payload = {
                    'action': 'initial_setup',
                    'CID': self._get_cid(),
                    'subaction': 'run',
                    'target_version': controller_version
                }
            else:
                print(
                    f"Attempting to upgrade software to {controller_version}")
                payload = {
                    'action': 'upgrade',
                    'CID': self._get_cid(),
                    'version': self.controller_version
                }
            response = requests.post(self.url, data=payload, verify=False)
            r = self._format_response(response)
            if r:
                if r.get('return') is True:
                    print
                    (f"Successfully updated software to: {controller_version}")
                    return True
            return False
        except requests.exceptions.Timeout:
            attempts = 10
            while attempts != 0:
                print(f"Attempts remaining to check software version: "
                      f" {attempts}")
                attempts -= 1
                if self._is_software_up_to_date(controller_version):
                    return True
                time.sleep(30)
                continue
            return False
        except Exception as err:
            print(str(err))
            return False

    def perform_software_updates(self):
        if self._is_software_up_to_date(self.controller_version):
            return
        # If controller is being upgraded to 6.6 then do the initial software
        # update then upgrade from 6.5 to 6.6
        elif self.controller_version == "6.6":
            result = self.software_update("6.5", initial_upgrade=True)
            if result:
                result = self.software_update("6.6", initial_upgrade=False)
            else:
                raise Exception("Failed to update to 6.6")
        # If controller is not being upgraded to 6.6 then only do
        # initial_software_update
        else:
            result = self.software_update(self.controller_version,
                                          initial_upgrade=True)
        if result:
            print("All Software Updates Succeeded.")
            return True
        print("All attempts to update software failed")
        sys.exit(1)

    def primary_aws_account(self, primary_account_name):
        if not os.getenv('AWS_PRIMARY_ACCOUNT_NUMBER'):
            raise Exception("Environment variable "
                            "'AWS_PRIMARY_ACCOUNT_NUMBER' must be defined")
        self.primary_access_account = primary_account_name
        print("Checking if account already exists.")
        if self._does_account_exist(primary_account_name) is True:
            return
        else:
            print("Attempting to add AWS Primary IAM Account.")
            payload = {
                'action': 'setup_account_profile',
                'CID': self._get_cid(),
                'account_name': primary_account_name,
                'cloud_type': 1,
                'account_email': self.admin_email,
                'aws_account_number': os.getenv('AWS_PRIMARY_ACCOUNT_NUMBER'),
                'aws_iam': 'true'
            }
            self._format_response(
                requests.post(self.url, data=payload, verify=False))
            print(f"Successfully added {primary_account_name}.")

    def enable_security_group_management(self):
        print("Enabling auto security group management")
        payload = {
            'action': 'enable_controller_security_group_management',
            'CID': self._get_cid(),
            'access_account_name': self.primary_access_account
        }
        self._format_response(
            requests.post(self.url, data=payload, verify=False))
        print("Successfully enabled auto security group management.")


def main():
    controller = ControllerSetup()

    controller._check_environment_vars()
    controller.set_admin_email()
    controller.reset_admin_password()
    controller.set_customer_id()
    controller.perform_software_updates()

    if os.getenv('AWS_PRIMARY_ACCOUNT_NAME'):
        controller.primary_aws_account(os.getenv('AWS_PRIMARY_ACCOUNT_NAME'))
        controller.enable_security_group_management()


main()
sys.exit(0)
