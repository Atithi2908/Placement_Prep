const mongoose = require ('mongoose');

const JobSchema = new mongoose.Schema({
 title: { type: String, required: true },
  description: String,
  location: String,
  salary: Number,
  postedAt: { type: Date, default: Date.now },
  
  employer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Employer',
    required: true
  }
});

module.exports = mongoose.model('Job', JobSchema);