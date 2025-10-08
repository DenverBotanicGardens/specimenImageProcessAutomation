@echo
for %%a in ("Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.cr2") do (
    "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe" -c -fl -cr2.4 -u -d "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted" "%%a"
)

REM Path to Adobe Photoshop executable
set photoshop_path="C:\Program Files\Adobe\Adobe Photoshop 2025\Photoshop.exe"

REM Path to the JavaScript script file
set script_path="C:\DBG_ImageProcessor\photoshop.jsx"

REM Execute the script in Photoshop
%photoshop_path% %script_path%

REM Forcefully close Photoshop after script execution
taskkill /IM Photoshop.exe /F

REM Move all web versions to local DBG NetX Import Folder
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\To_Be_Compressed\JPEG\*.jpg Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_NetxIO

REM Run NetX IO Import
java -Xms512M -Xmx2048M -cp "C:\Users\richard.levy\NetxIO\netxio-4.3.2.jar" com.netxposure.external.client.io.NetxIO -config "C:\Users\richard.levy\NetxIO\netxio_dbg_Import.properties"

REM Move the DNG files into the DNG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.dng Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_DNG

REM Move the .CR2 raw files into the RAW All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.CR2 Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_RAW

REM Move the .JPG raw files into the JPG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeCompressed\*.JPG Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_JPEG

REM Process Complete. Images on server ready for mapping on Mycoportal

pause