const express = require('express');
const router = express.Router();
const Job = require('../models/Job');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const JWT_SECRET ="atithi@1234";

const authMiddleware = (req, res, next) => {
    const token = req.headers['token'];
    if (!token) {
        return res.status(401).json({ message: 'No token, authorization denied' });
    }
    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        req.user = decoded;
        console.log('Decoded token:', decoded);
        next();
    } catch (error) {
        console.error('Token verification failed:', error);
        res.status(401).json({ message: 'Token is not valid' });
    }
};

router.post('/create',authMiddleware,async(req,res)=>{
    try{
        const { title, description, location, salary } = req.body;
        const newJob = new Job({
            title,
            description,
            location,
            salary,
            employer: req.user.id 
        });
  console.log('Creating job with data:', newJob);
        await newJob.save();
        res.status(201).json({ message: 'Job created successfully', job: newJob });
    }
    catch (error) {
        console.error('Error creating job:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }

})
module.exports = router;