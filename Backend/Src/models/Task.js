const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({

    userId:{
        type:mongoose.Schema.Types.ObjectId,
        ref:'User',
        required:true
    },

    Date:{
        type:Date,
        required:true
    },

    Task:[
        {
         title:{
            type:String,
            required:true
         },
         completed:{
            type:Boolean,
            default:false
         }  
        }
    ]

},
 { timestamps: true });

 const task = mongoose.model('Task', taskSchema);
module.exports = task;
