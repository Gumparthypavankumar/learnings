const express = require('express');
const app = express();
const mongoose = require("mongoose");
const PORT = process.env.PORT || 5000;
const keys = require("./config/keys")

app.use(express.json());

mongoose.connect(keys.mongoURI, {})
.then(res => console.log("MongDB Connected"))
.catch(err => console.error({err}))
;

app.use("/products", require("./routes/Product"));

app.listen(PORT, () => console.log(`App started on port: ${PORT}`));