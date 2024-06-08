const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;
const mongoose = require('mongoose');
const keys = require('./config/keys');

// Map Global Promise - get rid of warning 
mongoose.Promise = global.Promise;

/**
 * Establishes a connection to MongoDB using Mongoose
 */
function connectToMongoDB() {
  mongoose.connect(keys.mongoURI)
  .then(res => console.log('MongoDB Connected...'))
  .catch(err => console.log({err}));
}

connectToMongoDB();

app.listen(PORT, () => console.log(`App listening on port: ${PORT}`));