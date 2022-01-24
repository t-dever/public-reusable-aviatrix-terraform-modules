import os
import json
import xmltodict
import requests
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class PaloAlto():
    def __init__(self):
        self.ip_address = os.getenv('IP_ADDRESS')
        self.username = os.getenv('USERNAME')
        self.password = os.getenv('PASSWORD')
        self.url = f"https://{self.ip_address}/api/v9.1"
        self.access_key = self._get_access_key()

    def _parse_xml(self, data):
        xml = xmltodict.parse(data)
        json_data = json.loads(json.dumps(xml))
        return json_data

    def _get_access_key(self):
        url = f"{self.url}?type=keygen&user={self.username}&password={self.password}"
        response = requests.get(url, verify=False)
        parsed_data = self._parse_xml(response.text)
        access_key = parsed_data['response']['result']['key']
        return access_key
    
    def commit(self):
        print("Performing Commit")
        url = f"{self.url}?key={self.access_key}&type=commit&cmd=<commit></commit>"
        response = requests.get(url, verify=False)
        print(response.text)


palo = PaloAlto()
palo.commit()