const fs = require("fs");

function readFileContent(filepath) {
    fs.readFile(filepath, { encoding: 'utf-8', flag: 'r'}, (err, data) => {
        if(err) {
            console.error(`Error reading file: ${err.message}`);
        }
        console.log(data);
    })    
}


readFileContent('./test-files/file1.txt');
// Expected Output: Content of file1.txt

readFileContent('./test-files/empty-file.txt');
// Expected Output: (empty string)

readFileContent('test-files/nonexistent-file.txt');
// Expected Output: Error reading file: ENOENT: no such file or directory...