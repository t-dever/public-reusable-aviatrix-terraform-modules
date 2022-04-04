import os
import sys
import time
import requests
import urllib3
from distutils.util import strtobool

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
        self.azure_primary_account_name = os.getenv('AZURE_PRIMARY_ACCOUNT_NAME')
        self.azure_primary_account_subscription_id = os.getenv('AZURE_PRIMARY_ACCOUNT_SUBSCRIPTION_ID')
        self.azure_primary_account_tenant_id = os.getenv('AZURE_PRIMARY_ACCOUNT_TENANT_ID')
        self.azure_primary_account_client_id = os.getenv('AZURE_PRIMARY_ACCOUNT_CLIENT_ID')
        self.azure_primary_account_client_secret = os.getenv('AZURE_PRIMARY_ACCOUNT_CLIENT_SECRET')
        self.aws_primary_account_name = os.getenv('AWS_PRIMARY_ACCOUNT_NAME')
        self.aws_primary_account_number = os.getenv('AWS_PRIMARY_ACCOUNT_NUMBER')
        if os.getenv('AWS_GOV'):
            self.is_aws_gov = strtobool(os.getenv('AWS_GOV'))
        self.aws_role_app_arn = os.getenv('AWS_ROLE_APP_ARN')
        self.aws_role_ec2_arn = os.getenv('AWS_ROLE_EC2_ARN')
        self.security_group_management = strtobool(os.getenv('ENABLE_SECURITY_GROUP_MANAGEMENT'))
        self.copilot_username = os.getenv('COPILOT_USERNAME')
        self.copilot_password = os.getenv('COPILOT_PASSWORD')

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

        print("Failed to return status code 200")
        print(response.status_code)
        print(response.text)
        raise Exception(response.text)

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

    def software_update(self):
        try:
            if self._is_software_up_to_date(self.controller_version):
                return
            print(
                f"Attempting to upgrade software to {self.controller_version}")
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
                    (f"Successfully updated software to: {self.controller_version}")
                    return True
                else:
                    print(f"Failed to update software due to: '{r.get('reason')}'")
                    sys.exit(1)
        except requests.exceptions.Timeout:
            attempts = 10
            while attempts != 0:
                print(f"Attempts remaining to check software version: "
                      f" {attempts}")
                attempts -= 1
                if self._is_software_up_to_date(self.controller_version):
                    return True
                time.sleep(30)
                continue
            print("Timeout Exception has occurred.")
            sys.exit(1)
        except Exception as err:
            print(str(err))
            sys.exit(1)

    def primary_aws_account(self):
        if not self.aws_primary_account_number:
            raise Exception("Environment variable "
                            "'AWS_PRIMARY_ACCOUNT_NUMBER' must be defined")
        self.primary_access_account = self.aws_primary_account_name
        print("Checking if account already exists.")
        if self._does_account_exist(self.aws_primary_account_name) is True:
            return
        else:
            print("Attempting to add AWS Primary IAM Account.")
            payload = {
                'action': 'setup_account_profile',
                'CID': self._get_cid(),
                'account_name': self.aws_primary_account_name,
                'account_email': self.admin_email
            }
            if self.is_aws_gov:
                payload['cloud_type'] = 256
                payload['awsgov_account_number'] = self.aws_primary_account_number
                payload['awsgov_iam'] = 'true'
                payload['awsgov_role_arn'] = self.aws_role_app_arn
                payload['awsgov_role_ec2'] = self.aws_role_ec2_arn
            else:
                payload['cloud_type'] = 1
                payload['aws_account_number'] = self.aws_primary_account_number
                payload['aws_iam'] = 'true'
                payload['aws_role_arn'] = self.aws_role_app_arn
                payload['aws_role_ec2'] = self.aws_role_ec2_arn
            response = self._format_response(
                requests.post(self.url, data=payload, verify=False))
            if response.get('return') == False:
                if response.get('reason'):
                    print(f"Failed to add account: '{self.aws_primary_account_name}'"
                          f" due to Error: '{response.get('reason')}'")
                raise Exception(response)
            print(f"Successfully added {self.aws_primary_account_name}.")

    def primary_azure_account(self):
        if not self.azure_primary_account_subscription_id:
            raise Exception("Environment variable "
                            "'AZURE_PRIMARY_ACCOUNT_SUBSCRIPTION_ID' must be defined")
        elif not self.azure_primary_account_tenant_id:
            raise Exception("Environment variable "
                            "'AZURE_PRIMARY_ACCOUNT_TENANT_ID' must be defined")
        elif not self.azure_primary_account_client_id:
            raise Exception("Environment variable "
                            "'AZURE_PRIMARY_ACCOUNT_CLIENT_ID' must be defined")
        elif not self.azure_primary_account_client_secret:
            raise Exception("Environment variable "
                            "'AZURE_PRIMARY_ACCOUNT_CLIENT_SECRET' must be defined")
        self.primary_access_account = self.azure_primary_account_name
        print("Checking if account already exists.")
        if self._does_account_exist(self.primary_access_account) is True:
            return
        else:
            print("Attempting to add Azure Primary Account.")
            payload = {
                'action': 'setup_account_profile',
                'CID': self._get_cid(),
                'account_name': self.primary_access_account,
                'account_email': self.admin_email,
                'cloud_type': 8,
                'arm_subscription_id': self.azure_primary_account_subscription_id,
                'arm_application_endpoint': self.azure_primary_account_tenant_id,
                'arm_application_client_id': self.azure_primary_account_client_id,
                'arm_application_client_secret': self.azure_primary_account_client_secret
            }
            response = self._format_response(
                requests.post(self.url, data=payload, verify=False))
            if response.get('return') == False:
                if response.get('reason'):
                    print(f"Failed to add account: '{self.aws_primary_account_name}'"
                          f" due to Error: '{response.get('reason')}'")
                raise Exception(response)
            print(f"Successfully added {self.aws_primary_account_name}.")

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

    def add_copilot_user_account(self):
        print(f"Checking if Copilot Account {self.copilot_username} already exists.")
        if self._does_account_exist(self.copilot_username) is True:
            return
        else:
            print(f"Adding CoPilot User Account")
            payload = {
                'action': 'add_account_user',
                'CID': self._get_cid(),
                'username': self.copilot_username,
                'password': self.copilot_password,
                'email': self.admin_email,
                'groups': "read_only"
            }
            response = self._format_response(
                requests.post(self.url, data=payload, verify=False))
            if response.get('return') == False:
                if response.get('reason'):
                    print(f"Failed to add account: '{self.copilot_username}'"
                          f" due to Error: '{response.get('reason')}'")
                raise Exception(response)
            print(f"Successfully added {self.copilot_username}.")


def main():
    controller = ControllerSetup()

    controller._check_environment_vars()
    controller.set_admin_email()
    controller.reset_admin_password()
    controller.set_customer_id()
    controller.software_update()

    if controller.aws_primary_account_name:
        controller.primary_aws_account()
    if controller.azure_primary_account_name:
        controller.primary_azure_account()
    if controller.security_group_management:
        controller.enable_security_group_management()
    if controller.copilot_username and controller.copilot_password:
        controller.add_copilot_user_account()

main()
sys.exit(0)
