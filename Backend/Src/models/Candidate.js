const mongoose = require('mongoose');

const candidateSchema = new mongoose.Schema({
  name: {
    type: String,     
    required: true    
  },
  email: {
    type: String,    
    required: true   
  },
  password: {
    type: String,  
    required: true    
  },
  phone: {
    type: String,     
    required: false   
  },
  joinedGroups: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group'
  }],
}, { timestamps: true }); 

module.exports = mongoose.model('Candidate', candidateSchema);
