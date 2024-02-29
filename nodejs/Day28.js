const http = require("http");
const express = require("express");
const app = express();
const socketio = require("socket.io");

const server = http.createServer(app);
const io = socketio(server);

io.on("connection", (socket) => {

  socket.on("message", (msg) => {
    console.log({msg});
    socket.broadcast.emit(
        "notify",
        `${socket.id} has Joined a chat`
      );
  });

  //When client disconnects
  socket.on("disconnect", () => {
    console.log(`Client disconnected ${socket.id}`);
    socket.broadcast.emit(
        "notify",
        `${socket.id} has left chat`
      );
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server started at port ${PORT}`);
});