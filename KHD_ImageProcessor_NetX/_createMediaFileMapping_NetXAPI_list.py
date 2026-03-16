import requests
import csv
import re
from datetime import datetime

# -----------------------------------
# CONFIGURATION
# -----------------------------------
NETX_URL = "https://botanicgardens.netx.net/api/rpc"
API_TOKEN = ""
FOLDER_ID = 77
FILE_LIST_PATH = r"C:\KHD_ImageProcessor\fileList.txt"

# -----------------------------------
# READ FILENAMES FROM TEXT FILE
# -----------------------------------
with open(FILE_LIST_PATH, "r", encoding="utf-8") as f:
    filename_list = [line.strip() for line in f if line.strip()]

if not filename_list:
    raise ValueError("fileList.txt is empty.")

# -----------------------------------
# BUILD OR CONDITIONS FOR FILENAMES
# -----------------------------------
filename_subquery = {
    "operator": "and",
    "subquery": {
        "query": [
            {
                "operator": "or",
                "exact": {
                    "field": "fileName",
                    "value": name
                }
            }
            for name in filename_list
        ]
    }
}

# -----------------------------------
# BUILD REQUEST PAYLOAD
# -----------------------------------
payload = {
    "jsonrpc": "2.0",
    "id": "get_assets_by_filename",
    "method": "getAssetsByQuery",
    "params": [
        {
            "query": [
                {
                    "operator": "and",
                    "folder": {
                        "folderId": FOLDER_ID,
                        "recursive": False
                    }
                },
                filename_subquery
            ]
        },
        None,
        {
            "page": {"startIndex": 0, "size": 10000},
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
response.raise_for_status()

output = response.json()

if "error" in output:
    raise RuntimeError(f"NetX API error: {output['error']}")

data = output["result"]["results"]
print(f"Found {len(data)} assets.")

# -----------------------------------
# WRITE CSV
# -----------------------------------
todaysDate = datetime.today().strftime("%Y%m%d")
output_file = rf"C:\KHD_ImageProcessor\{todaysDate}_seientMediaImportMapping.csv"

base_url = "https://botanicgardens.netx.net/file/asset"
rights_url = "https://creativecommons.org/publicdomain/zero/1.0/"
pattern = re.compile(r"(KHD\d{8})", re.IGNORECASE)

with open(output_file, "w", newline="", encoding="utf-8") as csvfile:
    fieldnames = ["catalogNumber", "sortOccurrence", "url", "originalUrl", "thumbnailUrl", "rights"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    for item in data:
        file_obj = item["file"]
        asset_id = item["id"]
        name = file_obj["name"]

        match = pattern.search(name)
        if not match:
            raise ValueError(
                f"Filename does not contain a valid catalog number (KHD########): {name}"
            )

        catalog_number = match.group(1)

        writer.writerow({
            "catalogNumber": catalog_number,
            "sortOccurrence": 1,
            "url": f"{base_url}/{asset_id}/preview/{name}",
            "originalUrl": f"{base_url}/{asset_id}/original/{name}",
            "thumbnailUrl": f"{base_url}/{asset_id}/thumb/{name}",
            "rights": rights_url
        })

print(f"CSV saved as {output_file}")