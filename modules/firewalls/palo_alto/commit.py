import os
import json
import xmltodict
import requests
import urllib3
import base64
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

class PaloAlto():
    def __init__(self):
        self.ip_address = "20.72.145.167"
        self.username = "fwadmin"
        self.password = "Aviatrix#1234"
        self.url = f"https://{self.ip_address}/api/"

    def _parse_xml(self, data):
        xml = xmltodict.parse(data)
        json_data = json.loads(json.dumps(xml))
        return json_data

    def _get_access_key(self):
        url = f"{self.url}?type=keygen&user={self.username}&password={self.password}"
        print(url)
        response = requests.get(url, verify=False)
        print(f"Response Code: {response}")
        print(f"Response Text: {response.text}")
        parsed_data = self._parse_xml(response.text)
        print(f"Parsed Data: {parsed_data}")
        access_key = parsed_data['response']['result']['key']
        return access_key
    
    def commit(self):
        print("Performing Commit")
        url = f"{self.url}?&type=commit&cmd=<commit></commit>"
        response = requests.get(url, verify=False, auth=(self.username, self.password))
        print(response.text)


palo = PaloAlto()
palo.commit()