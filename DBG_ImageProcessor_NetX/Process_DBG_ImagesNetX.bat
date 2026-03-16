@echo
REM Move all renamed JPG files to their temporary processing location
for /R "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_Incoming" %%F in (DBG-F-??????.jpg) do (
    move "%%F" "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_JPEG_temp"
)
REM Move all renamed CR2 files to their temporary processing location
for /R "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_Incoming" %%F in (DBG-F-??????.CR2) do (
    move "%%F" "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted"
)

REM Create DNG derivatives from CR2s
for %%a in ("Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.cr2") do (
    "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe" -c -fl -cr2.4 -u -d "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted" "%%a"
)


REM Copy all JPGs to Local NetX Folder
xcopy "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_JPEG_temp\*" "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_NetXIO"


REM Save list of all JPG file names copied to NetXIO
dir /b "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_JPEG_temp\*.JPG" > "C:\DBG_ImageProcessor\fileList.txt"

REM Run NetX IO Import
java -Xms512M -Xmx2048M -cp "C:\Users\richard.levy\NetxIO\netxio-4.3.2.jar" com.netxposure.external.client.io.NetxIO -config "C:\Users\richard.levy\NetxIO\netxio_dbg_Import.properties"

REM Move the DNG files into the DNG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.dng Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_DNG

REM Move the .CR2 raw files into the RAW All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.CR2 Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_RAW

REM Move the .JPG raw files into the JPG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_JPEG_temp\*.JPG Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_JPEG

REM Create the Media Mapping File
python "C:\DBG_ImageProcessor\scripts\createMediaFileMapping_NetXAPI_list.py"

REM Process Complete. Images on server ready for mapping on Mycoportal using the Extended Data Import Tool.

pause