@echo
for %%a in ("Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.cr2") do (
    "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe" -c -fl -cr2.4 -u -d "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted" "%%a"
)

REM Path to Adobe Photoshop executable
set photoshop_path="C:\Program Files\Adobe\Adobe Photoshop 2025\Photoshop.exe"

REM Path to the JavaScript script file
set script_path="C:\KHD_ImageProcessor\photoshop.jsx"

REM Execute the script in Photoshop
%photoshop_path% %script_path%

REM Forcefully close Photoshop after script execution
taskkill /IM Photoshop.exe /F

REM Move all web versions to local KHD NetX Import Folder
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Compressed\JPEG\*.jpg Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_NetxIO

REM Run NetX IO Import
java -Xms512M -Xmx2048M -cp "C:\Users\richard.levy\NetxIO\netxio-4.3.2.jar" com.netxposure.external.client.io.NetxIO -config "C:\Users\richard.levy\NetxIO\netxio_khd_Import.properties"


REM Move the DNG files into the DNG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.dng Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_DNG_ALL

REM Move the .CR2 raw files into the RAW All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.CR2 Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_RAW_ALL

REM Move the .JPG raw files into the JPG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Compressed\*.JPG Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_JPEG_ALL

REM Process Complete. Images are being sent to GLOBUS. You will recieve an email when they are ready for mapping on SEINet. Use the KU Globus Image Processing Profile.

pause