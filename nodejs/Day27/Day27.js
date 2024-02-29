const express = require("express");
const app = express();
const PORT = process.env.PORT || 5000;
const jwtService = require("./service/Jwt");
const state = require("./state/Users");


app.use(express.json());

const authenticateAndAuthorize = (req, res, next) => {
    if((req.url === "/users/login")) {
        next();
    }
    else if ((req.url === "/users" && req.method.toLowerCase() === "post")) {
        next();
    }
    else {
        try {
        const token = req.headers['authorization'];
        if(!token) {
            return res.status(401).json({"error": "Unauthorized", "error_description": "Token could not be found"});
        }
        const {username} = jwtService.verifyToken(token, "secret");
        const user = state.users.filter(u => u.username === username)[0];
        const isAuthorized = user.roles.some(role => role === "admin");
        if(!isAuthorized) {
            return res.status(403).json({"error": "Access Denied"});
        }
        next();
        } catch (err) {
            console.error({err});
            return res.status(500).json({"error" : "Internal Server error", "error_description": err.message});
        }
    }
}

app.use(authenticateAndAuthorize);
app.use("/users", require("./routes/User"));

app.listen(PORT, () => console.log(`App started on listening on port: ${PORT}`));