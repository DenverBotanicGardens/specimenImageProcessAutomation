# This script takes metadata exported from Netx and transforms it into a csv that can be imported into Symbiota for mapping images to their occurrence record

import pandas as pd

input_file = "metadata (2).csv"
output_file = "mycoportalMediaImportMapping.csv"

def enrich_metadata(input_file, output_file):
    # Read input CSV
    df = pd.read_csv(input_file)

    # Add enriched fields
    BASE = "https://botanicgardens.netx.net/file/asset"
    df["catalogNumber"] = df["file"].astype(str).str.replace(r"\.jpg$", "", case=False, regex=True)
    df["sortOccurrence"] = "1"
    df["url"] = BASE + "/" + df["assetId"].astype(str) + "/preview/" + df["file"].astype(str)
    df["originalUrl"] = BASE + "/" + df["assetId"].astype(str) + "/original/" + df["file"].astype(str)
    df["thumbnailUrl"] = BASE + "/" + df["assetId"].astype(str) + "/thumb/" + df["file"].astype(str)
    df["rights"] = "https://creativecommons.org/publicdomain/zero/1.0/"

    # Drop unwanted columns
    to_drop = [col for col in ["assetId", "file", "hidden"] if col in df.columns]
    df = df.drop(columns=to_drop)

    # Save result
    df.to_csv(output_file, index=False)
    print(f"Enriched file saved as {output_file}")

if __name__ == "__main__":
    enrich_metadata(input_file, output_file)
