const express = require('express');

const app = express();
const PORT = process.env.PORT || 5000;

app.get('/greet', (req, res) => {
    let name = req.query.name;
    if(name) {
        name = 'Guest'
    }
    return res.send(`Hello, ${name}!`);
});

app.listen(PORT, () => console.log(`App started listening on port ${PORT}`))