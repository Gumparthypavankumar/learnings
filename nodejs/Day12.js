const express = require('express');
const app = express();

const PORT = process.env.PORT || 5000;

const maximumAllowedRequestRate = 5;
const bucket = new Map();

/**
 * Rate-limiting middleware for Express
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
function rateLimitMiddleware(req, res, next) {
  const IP = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
  console.log(`IP identified as ${IP}`);
  if(!bucket.has(IP)) {
    bucket.set(IP, 1);
    next();
  } else if(bucket.get(IP) > maximumAllowedRequestRate) {
    return res.status(429).json({"error": "Access Denied", "error_description": "rate exceeded. Plase try after some time!!!"});
  }
  bucket.set(IP, bucket.get(IP) + 1);
  next();
}

app.use(rateLimitMiddleware);

app.get("/", (req, res) => {
    return res.status(200).json({"message" : "Successful"});
});

app.listen(PORT, () => console.log(`App listening on port ${PORT}`));