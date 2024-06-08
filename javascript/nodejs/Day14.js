const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;
const cache = {};

/**
 * Caching middleware for Express
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
function cachingMiddleware(req, res, next) {
  const url = req.url;
  const cachedResponse = cache[url];
  if(cachedResponse) {
    if (cachedResponse.expiration > Date.now()) {
        console.log("Sending cache response");
        return res.status(304).json(cachedResponse.body);
    }
  }
  next();
}

app.use(cachingMiddleware);

app.get("/data", (req, res) => {
    const data = {
        "name": "John Doe",
        "email": "john@email.com",
        "phone": "+93555-555-5555"
    };
    const date = new Date();
    date.setHours(date.getHours() + 1);
    cache[req.url] = {
        expiration: date,
        body: data
    };
    console.log({cache});
    return res.status(200).json(data);
});


app.listen(PORT, () => console.log(`App Listening on port: ${PORT}`));