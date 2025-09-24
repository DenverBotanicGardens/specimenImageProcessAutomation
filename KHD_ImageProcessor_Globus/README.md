# specimenImageProcessAutomation
a script that automates parts of the preserved specimen image process

## steps

1. Rename new images using Barcode Renamer Software
2. Move all CR2 files into ToBeConverted Folder
3. Move all JPG files into ToBeCompressed Folder
4. Run Process_KHD_Images.bat to create DNGs from RAWs, create web derivatives of JPGs, and move web derivatives to Globus server for ingestion.
5. Log into SEINet and run import process
6. Run DeleteWebVersions_KHD_Images.bat to remove web derivatives from local folder.


