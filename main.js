var express = require("express");
var app = express();
var fs = require("fs");

let amountOfReadFiles = 0;
var data = "";

app.get("/files", (req, res, next) => {
  console.log("-- /files --\n\n");

  //Read dir, get all files
  let aFiles = getAllFiles("files");

  let sFileContent = "";
  //get contents
  aFiles.forEach(function (sFileName) {
    sFileContent += "<file name=[" + sFileName + "]>";
    sFileContent += getFileContents(sFileName);
    sFileContent += "</file>";
  });

  sFileContent = JSON.stringify(sFileContent);
  sFileContent = sFileContent.replace(/\\n/g, "\n");
  sFileContent = sFileContent.replace(/\\r/g, "\r");
  sFileContent = sFileContent.replace(/\\"/g, '"');
  sFileContent = sFileContent.substr(1);
  sFileContent = sFileContent.substring(0, sFileContent.length - 1);
  res.send(sFileContent);
  //return the merged shizzle to mc

});

function getAllFiles(sDirname)
{
  let aFiles = [];
  let aFilenames = fs.readdirSync(sDirname);

  aFilenames.forEach(function (sFilename) {
    if (isDir(sDirname + "/" + sFilename))
      aFiles = aFiles.concat(getAllFiles(sDirname + "/" + sFilename));
    else 
      aFiles.push(sDirname + "/" + sFilename);
  });

  return aFiles;
}

function getFileContents(sFilePath)
{
  return fs.readFileSync(sFilePath, "utf-8");
}

function isDir(sPath)
{
  return fs.lstatSync(sPath).isDirectory();
}

app.listen(3000, () => {
  console.warn("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
  console.log("Server running on port 3000");
  console.warn("\n\n");

});
