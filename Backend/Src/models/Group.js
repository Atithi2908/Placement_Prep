const mongoose = require('mongoose');

const GroupSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true,
    },
    members:[
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Candidate',
            required: true
        }
    ],
    admins:[
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Candidate',
            required: true
        }
    ]

    }, { timestamps:true });
module.exports = mongoose.model('Group', GroupSchema);