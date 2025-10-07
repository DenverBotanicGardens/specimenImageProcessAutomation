# Automated Image Processing  
This set of scripts can be used to automate the steps required to process images of museum specimens and prepare them for import to Globus and accessed in Symbiota.  

These files, paths, directories refer to systems, processes, and locations used at Denver Botanic Gardens Kathryn Kalmbach Herbarium (KHD). File names and paths must be modified to work within the intended environment.  

These scripts are written to be used with Windows, but can be adapted to work in macOS or Linux.  

There are 3 files:  
`_Process_KHD_ImagesGlobus.bat`  
`photoshop.jsx`  
`_DeleteWebVersions_KHD_ImagesGlobus.bat`  

## What these scripts do

1. Creates a DNG version for each RAW image file
2. Creates a reduced quality web version of each .jpg image file
3. Imports web versions to Globus
4. Moves all DNG, RAW, and original JPG files to their permanent directories
5. Deletes all web versions from local directory

## Prerequisite Software 
- Adobe DNG Converter (https://helpx.adobe.com/camera-raw/using/adobe-dng-converter.html)  
- Adobe Photoshop

## Initial Set Up  
- A .jpg and .CR2 (or other RAW format) version for each specimen image  
- Image files are renamed to be the catalogNumber, or otherwise to meet collection needs  
  - We use barcod renamer by Daryl Lafferty (https://help.lichenportal.org/index.php/en/resources/renaming-image-files-automatically)  
- JPG files saved in a local directory  - "ToBeCompressed" in these scripts  
- RAW files saved in a local directory - "ToBeConverted" in these scripts  

## _Process_KHD_ImagesGlobus.bat  
This .bat file will run a process in the command line that does the following

Makes a .dng copy of each RAW file and saves it in the same location

<pre> for %%a in ("Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.cr2") do (
    "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe" -c -fl -cr2.4 -u -d "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted" "%%a"
) </pre>

Opens Photoshop, calls the photoshop.jsx file to creates a reduced quality web version of each .jpg file and saves it in a sub directory called JPEG
<pre>
REM Path to Adobe Photoshop executable
set photoshop_path="C:\Program Files\Adobe\Adobe Photoshop 2025\Photoshop.exe"

REM Path to the JavaScript script file
set script_path="C:\KHD_ImageProcessor\photoshop.jsx"

REM Execute the script in Photoshop
%photoshop_path% %script_path%

REM Forcefully close Photoshop after script execution
taskkill /IM Photoshop.exe /F
</pre>

Moves all newly created web versions and transfers to Globus
<pre>
REM Move all web versions to local GLOBUS folder
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Compressed\JPEG\*.jpg C:/KHD_ImageProcessor/GLOBUS

REM Execute transfer to Globus
globus transfer 37095bec-97df-11f0-a8ef-0e840c2393b5:C/KHD_ImageProcessor/GLOBUS 67d70bc9-c47a-4583-8a56-5edc02d263ec:/batch_image_upload/DBG/DBG_vascularplants/
</pre>


Moves all files to their permanent directories, overwrites already existing
<pre>
REM Move the DNG files into the DNG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.dng Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_DNG_ALL

REM Move the .CR2 raw files into the RAW All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.CR2 Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_RAW_ALL

REM Move the .JPG files into the JPG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Compressed\*.JPG Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_JPEG_ALL

REM Process Complete. Images are being sent to GLOBUS. Please wait 10 minutes before mapping on SEINet. Use the KU Globus Image Processing Profile.

pause
</pre>

## photoshop.jsx

This javascript file defines what Photoshop should do to create a reduced quality web version for each .jpg image file.

## _DeleteWebVersions_KHD_ImagesGlobus.bat

This .bat file can be run once all images are imported to Globus. It simply deletes all the reduced quality .jpg web version files from the local directory.

## Final Step - Run Image Processing within Symbiota  
To map the images from Globus to their corresponding specimen record, you must run the KU Globus processing profile within your Symbiota portal