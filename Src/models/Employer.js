const mongoose = require('mongoose');

const EmployerSchema = new mongoose.Schema({
    companyName: {
        type: String,
        required: true
    },
    companyEmail: {
        type: String,
        required: true
    },

    employerName: {
        type: String,
        required: true
    },
    
    password: {
        type: String,
        required: true
    },
    phone: {
        type: String,
        required: true
    }
}, { timestamps: true });

module.exports = mongoose.model('Employer', EmployerSchema);
