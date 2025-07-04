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
  }
}, { timestamps: true }); 

module.exports = mongoose.model('Candidate', candidateSchema);
