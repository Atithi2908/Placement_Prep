const mongoose  = require('mongoose');
const ApplicationSchema = new mongoose.Schema({
    job: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Job',
        required: true
    },
    candidate: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Candidate',
        required: true
    },
    status: {
        type: String,
        enum: ['applied', 'interviewed', 'offered', 'rejected'],
        default: 'applied'
    },
    appliedAt: { type: Date, default: Date.now }

})
module.exports = mongoose.model('Application', ApplicationSchema);
