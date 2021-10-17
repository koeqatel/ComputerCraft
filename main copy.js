var express = require("express");
var app = express();
var fs = require("fs");

let amountOfReadFiles = 0;
var data = "";

app.get("/files", (req, res, next) => {
  console.log("-- /files --");

  //Read dir, get all files
  aFiles = readDir("files/");

  fs.readdir("files/", function (err, filenames) {
    if (err) {
      onError(err);
      return;
    }

    console.warn(filenames);

    readFiles(
      "files/",
      function (filename, content) {
        data = data + "<file name=[" + filename + "]>";
        // data = data + "code of " + filename;
        data = data + content;
        data = data + "</file>";
        console.warn("amount: " + amountOfReadFiles);
        amountOfReadFiles = amountOfReadFiles + 1;
      },
      function (err) {}
    );

    checkIfDone(res);
  });
});

function readDir()
{
  aFiles = [];

  

  return aFiles;
}

function checkIfDone(res) {
  setTimeout(async () => {
    let filecount = await getFileCount();
    if (amountOfReadFiles >= (await getFileCount())) {     
      data = JSON.stringify(data);
      data = data.replace(/\\n/g, "\n");
      data = data.replace(/\\r/g, "\r");
      data = data.replace(/\\"/g, '"');
      data = data.substr(1);
      data = data.substring(0, data.length - 1);
      res.send(data);

      amountOfReadFiles = 0;
      data = "";
    } else {
      checkIfDone(amountOfReadFiles);
    }
  }, 3000);
}

function getFileCount() {
  return new Promise((resolve) => {
    fs.readdir("files/", function (err, filenames) {
      if (err) {
        onError(err);
        return;
      }
      resolve(filenames.length);
    });
  });
}

function readFiles(dirname, onFileContent, onError) {
  fs.readdir(dirname, function (err, filenames) {
    if (err) {
      onError(err);
      return;
    }

    filenames.forEach(async function (filename) {
      if (fs.lstatSync(dirname + filename).isDirectory())
        readFiles(dirname + filename, onFileContent, onError);

      fs.readFile(dirname + filename, "utf-8", function (err, content) {
        if (err) {
          onError(err);
          return;
        }
        onFileContent(filename, content);
      });
    });
  });
}