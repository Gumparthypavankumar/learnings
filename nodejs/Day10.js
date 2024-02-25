const express = require('express');
const app = express();
const path = require('node:path');

const PORT = process.env.PORT || 5000;

app.use(express.static(path.join(__dirname,'public')));

/**
 * Express application serving static files from the "public" directory
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
function staticFileServer(req, res) {
  res.sendFile('./public/index.html', (err) => {
        console.error('Error occurred', {err});
    });
}

app.get('/', staticFileServer);

app.listen(PORT, () => console.log(`App listening on port: ${PORT}`));