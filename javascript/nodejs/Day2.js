const fs = require("node:fs");

function writeToFile(filepath, content) {
    fs.writeFile(filepath, content, {encoding:'utf-8'}, (err) => {
        if(err) {
            console.error(`Error writing to file: ${err.message}`);
        }
    });
}

writeToFile('./test-files/output1.txt', 'Sample content.');
// Expected Output: Data written to output1.txt

writeToFile('./test-files/nonexistent-folder/output.txt', 'Content in a non-existent folder.');
// Expected Output: Error writing to file: ENOENT: no such file or directory...