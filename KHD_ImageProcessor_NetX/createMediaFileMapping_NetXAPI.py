#  This script uses the NetX API to obtain the attribute data from KHD specimen images imported "today"
#  The attribute data is then transformed into a csv that, when imported to Symbiota, maps images on NetX with records in Symbiota

import requests
import json
from datetime import datetime, timedelta, timezone
from zoneinfo import ZoneInfo  # Python 3.9+
import pandas as pd
import csv

# -----------------------------------
# CONFIGURATION
# -----------------------------------
NETX_URL = "https://botanicgardens.netx.net/api/rpc"
API_TOKEN = ""
FOLDER_ID = 77

#Calculate "today"
denver_offset = timedelta(hours=-6)
now = datetime.now(timezone(denver_offset))
start_of_today = datetime(now.year, now.month, now.day, tzinfo=timezone(denver_offset))
start_of_tomorrow = start_of_today + timedelta(days=1)

min_ms = int(start_of_today.timestamp() * 1000)
max_ms = int(start_of_tomorrow.timestamp() * 1000)


# -----------------------------------
# BUILD REQUEST PAYLOAD
# -----------------------------------
payload = {
    "jsonrpc": "2.0",
    "id": "get_assets_last_24h",
    "method": "getAssetsByQuery",
    "params": [
        {
            "query": [
                {
                    "operator": "and",
                    "folder": {"folderId": FOLDER_ID, "recursive": False}
                },
                {
                    "operator": "and",
                    "range": {
                        "field": "importDate",
                        "min": str(min_ms),
                        "max": str(max_ms),
                        "includeMin": True,
                        "includeMax": True
                    }
                }
            ]
        },
        None,  # Python's None replaces JSON's null
        {
            "page": {"startIndex": 0, "size": 1000},
            "data": ["asset.id", "asset.file"]
        }
    ]
}

# -----------------------------------
# MAKE REQUEST
# -----------------------------------
headers = {
    "Content-Type": "application/json",
    "Authorization": f"apiToken {API_TOKEN}"
}

response = requests.post(NETX_URL, headers=headers, json=payload)

output = response.json()
resultObj = (output["result"]["results"])
print(resultObj)

data = resultObj

todaysDate = datetime.today().strftime("%Y%m%d")

output_file = f"{todaysDate}_seinetMediaImportMapping.csv"

base_url = "https://botanicgardens.netx.net/file/asset"
rights_url = "https://creativecommons.org/publicdomain/zero/1.0/"

with open(output_file, "w", newline="", encoding="utf-8") as csvfile:
    fieldnames = ["catalogNumber", "sortOccurrence", "url", "originalUrl", "thumbnailUrl", "rights"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    for item in data:
        file = item["file"]
        id_ = item["id"]
        name = file["name"]
        catalog_number = name.replace(".JPG", "")
        writer.writerow({
            "catalogNumber": catalog_number,
            "sortOccurrence": 1,
            "url": f"{base_url}/{id_}/preview/{name}",
            "originalUrl": f"{base_url}/{id_}/original/{name}",
            "thumbnailUrl": f"{base_url}/{id_}/thumb/{name}",
            "rights": rights_url
        })

print(f"CSV saved as {output_file}")