const express = require('express');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(requestLoggerMiddleware);

app.get('/greet', (req, res) => {
    let name = req.query.name || 'Guest';
    return res.send(`Hello, ${name}!`);
});

/**
 * Express middleware to log incoming requests
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
function requestLoggerMiddleware(req, res, next) {
    const date = new Date();
    const { method } = req;
    console.log(`${date.toISOString()} - ${method} request received`);
    next();
}

app.listen(PORT, () => console.log(`App started listening on port ${PORT}`))