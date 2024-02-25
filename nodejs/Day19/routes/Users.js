const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

require('../models/User');

const User = mongoose.model('users');

router.post('/', async (req, res) => {
  const {username, email} = req.body;
  try {
    const user = await User.create({
        username,
        email
      });
    return res.status(201).json({user});
  } catch(err) {
    if(err instanceof mongoose.Error.ValidationError){
      return res.status(400).json({"errors" : err.errors});
    }
    throw err;
  }
});


router.get("/", async (req, res) => {
  const users = await User.find();
  return res.status(200).json({data: users})
})

module.exports = router;