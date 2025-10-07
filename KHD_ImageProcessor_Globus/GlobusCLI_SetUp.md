# Setting Up Globus CLI Instructions (Windows)

## Prerequisites
- Git Bash (https://git-scm.com/downloads)
- pip (https://pip.pypa.io/en/stable/installation/)
- Globus Connect Personal (https://docs.globus.org/globus-connect-personal/install/)

## Setup

Open a bash terminal and run the following to install the Globus CLI:
`pip install --user globus-cli`

Once installed run the following to login to Globus:  
`globus login`  
Your web browser will open and allow you to log in.  
After logging in, your credentials will be stored locally on the machine you are using.


Now you must identify the 2 endpoints:
1. the local endpoint/name of your computer defined you in Globus
2. the remote endpoint/collection where you want to transfer images to  

Run the following to find the local endpoint:  
`globus endpoint search "Whatever you named your computer"`  
Copy the endpoint id and paste it somewhere you can access. will look like this: 1234abcd-5678-efgh.....

Run the following to find the remote endpoint:  
`globus endpoint search "KU Symbiota root"`  
Copy the endpoint id and paste it somewhere you can access. will look like this: 1234abcd-5678-efgh.....


Now that you have both endpoints, you can use the following command to transfer the files:  
`globus transfer <LOCAL_ENDPOINT_ID>:path/to/local/file <KU Symbiota root>:path/to/remote/folder/`


For example, the command should look like this:  
`globus transfer 12345678-97df-11f0-4589-0e840c2393b5:C/KHD_ImageProcessor/GLOBUS 12345678-c47a-4583-8a56-5edc02d263ec:/batch_image_upload/DBG/DBG_vascularplants/`  
Where `C/KHD_ImageProcessor/GLOBUS` is the folder on the local machine where images to be uploaded are placed  
And `/batch_image_upload/DBG/DBG_vascularplants/` is the "Path" set on Globus under the Ku Symbiota Root "Colleciton"
