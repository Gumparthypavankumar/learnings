const path = require("node:path");

function resolvePath(relativePath) {
    const resolvedPath = path.resolve(__dirname, relativePath);
    console.log(resolvedPath);
}

resolvePath('./test-file/file.txt');
// Expected Output: Resolved Path: /Users/username/project/folder/file.txt

resolvePath('nonexistent-folder/file.txt');
// Expected Output: Resolved Path: /Users/username/nonexistent-folder/file.txt