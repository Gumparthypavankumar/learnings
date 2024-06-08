const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true
    },
    email : {
        type: String,
        required: true,
        validate: {
        validator: function(prop) {
            return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(prop);
        },
        message: props => `${props.value} is not a valid email!`
        },
    }
});

mongoose.model('users', UserSchema);