const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

require('../models/User');

const User = mongoose.model('users');

router.post('/', async (req, res) => {
  const {username, email} = req.body;
  const user = await User.create({
    username,
    email
  });
  return res.status(201).json({user});
});


router.get("/", async (req, res) => {
  const users = await User.find();
  return res.status(200).json({data: users})
})

module.exports = router;