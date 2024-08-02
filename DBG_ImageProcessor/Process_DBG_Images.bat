@echo
for %%a in ("Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.cr2") do (
    "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe" -c -fl -cr2.4 -u -d "Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted" "%%a"
)

REM Path to Adobe Photoshop executable
set photoshop_path="C:\Program Files\Adobe\Adobe Photoshop 2023\Photoshop.exe"

REM Path to the JavaScript script file
set script_path="C:\DBG_ImageProcessor\photoshop.jsx"

REM Execute the script in Photoshop
%photoshop_path% %script_path%

REM run a script that creats a session in WinSCP and then moves all the web derivatives onto the remote server
"C:\Program Files (x86)\WinSCP\WinSCP.com" /script="C:\DBG_ImageProcessor\sftpScript.txt"


REM Move the DNG files into the DNG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.dng Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_DNG

REM Move the .CR2 raw files into the RAW All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeConverted\*.CR2 Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_RAW

REM Move the .JPG raw files into the JPG All folder and overwrite already existing
move /y Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_ToBeCompressed\*.JPG Q:\Research\Images(new)\MuseumSpecimens\DBG\DBG_Specimens\DBG_JPEG

REM Process Complete. Images on server ready for ingest on Mycoportal

pause