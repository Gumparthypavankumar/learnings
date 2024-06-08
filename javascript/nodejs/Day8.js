const express = require('express');
const app = express();

const PORT = process.env.PORT || 5000;

/**
 * Express route to handle requests with a positive integer parameter
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 */
function positiveIntegerHandler(req, res, next) {
    try {
        const number = parseInt(req.query.number);
        if(number < 0) return res.status(400).send("Bad Request!!!");
        next();
    } catch (err) {
        console.error({err});
        return res.status(400).send("Bad Request!!!");
    }
}

app.get("/positive", positiveIntegerHandler, (req, res) => {
    return res.status(200).send("Success");
});

app.listen(PORT, () => console.log(`App listening on port: ${PORT}`));