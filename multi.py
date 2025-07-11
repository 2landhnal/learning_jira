import requests
import json

url = "http://jira.internal/rest/api/2/mypermissions"

token = "NzM4NjY0NDI0NjcyOvqlXf8yJznQOT3c8p6eFt/KzI/+"

headers = {
    "Accept": "application/json",
    "Authorization": f"Bearer {token}"  
}

response = requests.get(url, headers=headers)

print("Status code:", response.status_code)
print("Raw response:")
print(response.text)

try:
    data = response.json()
    print(json.dumps(data, sort_keys=True, indent=4, separators=(",", ": ")))
except json.JSONDecodeError:
    print("❌ Response is not JSON!")

# curl -H "Authorization: Bearer NzM4NjY0NDI0NjcyOvqlXf8yJznQOT3c8p6eFt/KzI/+" http://jira.internal/rest/api/2/mypermissions