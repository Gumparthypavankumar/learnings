const path = require("node:path");
const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, "public")));

app.use(express.json());

app.use("/todos", require("./routes/todos.js"));

app.listen(PORT, () => console.log(`App started on port: ${PORT}`));