// Define input and output folders
var inputFolder = "Q:/Research/Images(new)/MuseumSpecimens/DBG/DBG_Specimens/DBG_ToBeCompressed"; // Replace with actual input folder path
var outputFolder = "Q:/Research/Images(new)/MuseumSpecimens/DBG/DBG_Specimens/DBG_ToBeCompressed/JPEG"; // Replace with actual output folder path

// Create output folder if it doesn't exist
var outputFolderObj = new Folder(outputFolder);
if (!outputFolderObj.exists) {
    outputFolderObj.create();
}

// Open all JPG files in input folder
var fileList = new Folder(inputFolder).getFiles("*.jpg");

// Process each file
for (var i = 0; i < fileList.length; i++) {
    var file = fileList[i];
    var doc = open(file);
    
    // Set JPEG options
    var options = new JPEGSaveOptions();
    options.quality = 9;

    // Save as JPEG in output folder
    var outputFileName = outputFolder + "/" + file.name;
    doc.saveAs(new File(outputFileName), options);

    // Close document
    doc.close(SaveOptions.DONOTSAVECHANGES);
}