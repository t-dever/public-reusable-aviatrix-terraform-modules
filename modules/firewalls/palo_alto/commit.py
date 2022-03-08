import os
import json
import requests
import urllib3
import base64
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

class PaloAlto():
    def __init__(self):
        self.ip_address = os.getenv('IP_ADDRESS')
        self.username = os.getenv('USERNAME')
        self.password = os.getenv('PASSWORD')
        self.url = f"https://{self.ip_address}/api/"
    
    def commit(self):
        print("Performing Commit")
        url = f"{self.url}?&type=commit&cmd=<commit></commit>"
        response = requests.get(url, auth=(self.username, self.password), verify=False)
        print(response.text)


palo = PaloAlto()
palo.commit()
