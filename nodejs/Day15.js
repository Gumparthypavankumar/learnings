const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());

/**
 * Logging middleware for Express
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
function loggingMiddleware(req, res, next) {
  const log = {
    timestamp: new Date(),
    url: req.url,
    method: req.method,
    request: {
        headers: req.headers,
        payload: req.body
    }
  };
  console.log(log);
  next();
}

app.use(loggingMiddleware);

app.post("/", (req, res) => {
    return res.status(200).json({"message" : "Success"});
});

app.listen(PORT, () => console.log(`App listening on port : ${PORT}`));