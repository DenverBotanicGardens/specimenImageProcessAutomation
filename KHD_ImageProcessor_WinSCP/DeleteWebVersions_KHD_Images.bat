@echo

REM Delete all web version .jpg files from remote server
"C:\Program Files (x86)\WinSCP\WinSCP.com" /script="C:\ImageProcessor\sftpScript_delete.txt"

REM Delete all web version .jpg files from JPEG FOLDER
del "Q:\Research\Images(new)\MuseumSpecimens\KHD\To_Be_Compressed\JPEG\*.jpg"

REM Process Finished. Web Versions removed from server and Q drive.

pause