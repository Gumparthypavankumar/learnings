const router = require('express').Router();
const state = require("../state/Users");
const jwtService = require("../service/Jwt");

router.post("/", (req, res) => {
    try {
        const { username, password, role } = req.body;
        const user = new User(username, password);
        user.addRole(role);
        state.users.push(user);
        return res.status(201).json({user});
    } catch (err) {
        console.error({err});
        return res.status(500).json({message: err.message});
    }
});

router.get("/", (req, res) => {
    try {
        return res.status(201).json({...state});
    } catch (err) {
        console.error({err});
        return res.status(500).json({message: err.message});
    }
})

router.post("/login", (req, res) => {
    try {
        const {username, password} = req.body;
        const user = state.users.filter((u) => u.username === username && u.password === password)[0];
        if(!user) {
            return res.status(401).json({"message": "Bad credentials"});
        }
        return res.status(200).json({token: jwtService.generateToken({username, password})});
    } catch (err) {
        console.error({err});
        return res.status(500).json({message: err.message});
    }
})

class User {
    constructor(username, password) {
        this.username = username;
        this.password = password;
        this.roles = [];
    }

    addRole(name) {
        this.roles.push(name); 
    }

    getRoles() {
        return this.roles;
    }
}

const generateToken = (payload) => {
    return jwt.sign(payload, secret, {algorithm: "HS256"});
}

module.exports = router;