const express = require('express');
const jwt = require('jsonwebtoken');
const app = express();
const uuid = require('uuid');
const PORT = process.env.PORT || 5000;
const jwtsecret = "secret";


app.post("/login", (req, res) => {
    const user = {
        username: 'John Doe',
        password: '12345678'
    }
    const signedToken = jwt.sign(user, jwtsecret, {algorithm: "HS256", expiresIn: 3600, subject: "Authorization token", jwtid: uuid.v4()});
    return res.status(200).json({"access_token": signedToken, "expires_in": 3600});
})

/**
 * Authentication middleware for Express
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
*/
function authenticationMiddleware(req, res, next) {
    const token = req.headers['authorization'];
    if(!token) {
        return res.status(401).json({"error": "Unauthorized", "error_description": "Token could not be found"});
    }
    try {
        jwt.verify(token, jwtsecret);
        next();
    } catch (err) {
        return res.status(401).json({"error": "Unauthorized", "error_description": "Please check authorization token"});
    }
}

app.use(authenticationMiddleware);

app.get("/", (req, res) => {
    return res.status(200).json({"message": "Welcome!!!"});
})

app.listen(PORT, () => console.log(`App listening on port ${PORT}`));