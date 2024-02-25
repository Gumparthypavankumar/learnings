const child = require("node:child_process");


function executeCommand(command) {
    try {
        const output = child.execSync(command, {encoding: 'utf-8'});
        console.log(output);
    } catch (err) {
        console.error(`Error executing command: ${command} with message: ${err.message}`);
    }
}

executeCommand('ls -la');
// Expected Output: (output of ls -la)

executeCommand('echo "Hello, Node.js!"');
// Expected Output: Hello, Node.js!