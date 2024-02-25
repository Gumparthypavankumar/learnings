const express = require('express');
const app = express();
const server = require('http').createServer(app);
const io = require('socket.io')(server);
const path = require("node:path");
const port = process.env.PORT || 3000;

app.use("/websocket", express.static(path.join(__dirname, "public")));

io.on('connection', (socket) => {
    console.log("Connected");

    socket.on('disconnect', () => {
        console.log('A user disconnected');
    });

    socket.on('message', (data) => {
        console.log(`Published message : ${data}`);
    });
});

server.listen(port, function() {
  console.log(`Listening on port ${port}`);
});