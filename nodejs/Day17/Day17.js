const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;
const mongoose = require('mongoose');
const keys = require('./config/keys');

app.use(express.json());

// Map Global Promise - get rid of warning 
mongoose.Promise = global.Promise;
require('./models/User');
const User = mongoose.model('users');

/**
 * Establishes a connection to MongoDB using Mongoose
 */
function connectToMongoDB() {
  mongoose.connect(keys.mongoURI, {
    dbName: "users"
  })
  .then(res => console.log('MongoDB Connected...'))
  .catch(err => console.log({err}));
}

connectToMongoDB();

app.post('/users', async (req, res) => {
  const {username, email} = req.body;
  const user = await User.create({
    username,
    email
  });
  return res.status(201).json({user});
});

app.listen(PORT, () => console.log(`App listening on port: ${PORT}`));