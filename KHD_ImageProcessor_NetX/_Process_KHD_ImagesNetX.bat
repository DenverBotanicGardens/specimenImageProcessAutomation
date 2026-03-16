@echo
REM Move all renamed JPG files to their temporary processing location
for /R "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Processed_Incoming" %%F in (KHD????????.jpg) do (
    move "%%F" "Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_JPEG_temp"
)
REM Move all renamed CR2 files to their temporary processing location
for /R "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Processed_Incoming" %%F in (KHD????????.CR2) do (
    move "%%F" "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted"
)

REM Create DNG derivatives from CR2s
for %%a in ("Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.cr2") do (
    "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe" -c -fl -cr2.4 -u -d "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted" "%%a"
)

REM Copy all JPGs to Local NetX Folder
xcopy "Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_JPEG_temp\*" "Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_NetxIO"

REM Save list of all JPG file names copied to NetXIO
dir /b "Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_JPEG_temp\*.JPG" > "C:\KHD_ImageProcessor\fileList.txt"

REM Run NetX IO Import
java -Xms512M -Xmx2048M -cp "C:\Users\richard.levy\NetxIO\netxio-4.3.2.jar" com.netxposure.external.client.io.NetxIO -config "C:\Users\richard.levy\NetxIO\netxio_khd_Import.properties"

REM Move the DNG files into the DNG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.dng Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_DNG_ALL

REM Move the .CR2 raw files into the RAW All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.CR2 Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_RAW_ALL

REM Move the .JPG raw files into the JPG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_JPEG_temp\*.JPG Q:\Research\Images(new)\MuseumSpecimens\KHD\KHD_JPEG_ALL

REM Create Media Mapping File
python "C:\KHD_ImageProcessor\createMediaFileMapping_NetXAPI_list.py"

REM Process Complete. Images are now available on NetX. They are ready for mapping on SEINet using the Extended Data Import Tool.
pause