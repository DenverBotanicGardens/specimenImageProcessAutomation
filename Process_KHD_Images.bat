@echo
for %%a in ("Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted\*.cr2") do (
    "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe" -c -fl -cr2.4 -u -d "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Converted" "%%a"
)

REM Path to Adobe Photoshop executable
set photoshop_path="C:\Program Files\Adobe\Adobe Photoshop 2023\Photoshop.exe"

REM Path to the JavaScript script file
set script_path="C:\ImageProcessor\photoshop.jsx"

REM Execute the script in Photoshop
%photoshop_path% %script_path%

REM run a script that creats a session in WinSCP and then moves all the web derivatives onto the remote server
"C:\Program Files (x86)\WinSCP\WinSCP.com" /script="C:\ImageProcessor\sftpScript.txt"