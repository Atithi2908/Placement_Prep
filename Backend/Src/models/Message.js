const mongoose = require('mongoose');

const MessageSchema = new mongoose.Schema({

groupId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group',
    required: true
},
senderId:{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Candidate',
    required: true
},
message: {
    type: String,
    required: true
},

timestamp: {
    type: Date,
    default: Date.now
}

},{ timestamps: true });
module.exports = mongoose.model('Message', MessageSchema);