const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema({
    question:String,
    options: [String],
    answer: String,
},{ collection: 'questions' });
module.exports = mongoose.model('Question', questionSchema);