const express = require('express');
const router = express.Router();
const Candidate = require('../models/Candidate');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const JWT_SECRET = "atithi@1234";
const Application = require('../models/Application');
const Job = require('../models/Job');

const authMiddleware = (req, res, next) => {
    
const token = req.headers['token'];
    if (!token) {
        return res.status(401).json({ message: 'No token, authorization denied' });
    }
    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        req.user = decoded;
        console.log('Decoded user:', req.user);

        next();
    } catch (error) {
        console.error('Token verification failed:', error);
        res.status(401).json({ message: 'Token is not valid' });
    }
};


router.post('/signup', async (req, res) => {
    const { name, email, password, phone } = req.body;
    try {
        const existingCandidate = await Candidate.findOne({ email });
        if (existingCandidate) {
            return res.status(400).json({ message: 'Candidate already exists' });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const newCandidate = new Candidate({
            name,
            email,
            password: hashedPassword,
            phone: phone
        })
        await newCandidate.save();
        res.status(201).json({ message: 'Candidate registered successfully' });
    } catch (error) {
        console.error('Error during signup:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.post('/signin', async (req, res) => {
    const { email, password } = req.body;
    try {
        const candidate = await Candidate.findOne({ email });
        if (!candidate) {
            return res.status(400).json({ message: 'Candidate not found' });
        }
        const isMatch = await bcrypt.compare(password, candidate.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }
        const token = jwt.sign({
            id: candidate._id,
            email: candidate.email,
        }, JWT_SECRET, {
            expiresIn: '1h'
        });
        res.status(200).json({ token, candidateId: candidate._id, candidateName: candidate.name });
    } catch (error) {
        console.error('Error during signin:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.get('/getdetails', authMiddleware, async (req, res) => {
    try {
        const candidate = await Candidate.findOne({ email: req.user.email });
        if (!candidate) {
            return res.status(400).json({ message: 'Candidate not found' });
        }
        res.status(200).json({ candidate });
    }
    catch (error) {
        console.error('Error fetching candidate details:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});
router.post('/apply', authMiddleware, async (req, res) => {
    try {
        const { job_Id } = req.body;
        const userId = req.user.id;


        const jobExists = await Job.findById(job_Id);
        if (!jobExists) {
            return res.status(404).json({ message: 'Job not found' });
        }

                            
        const alreadyApplied = await Application.findOne({ candidate: userId, job: job_Id });
        if (alreadyApplied) {
            return res.status(400).json({ message: 'You have already applied for this job' });
        }


        const newApplication = new Application({
            job: job_Id,
            candidate: userId
        });
        console.log('Applying to job with data:', newApplication);

        await newApplication.save();

        res.status(201).json({ message: 'Application submitted successfully' });
    } catch (error) {
        console.error('Error applying to job:', error);
        res.status(500).json({ message: 'Server error' });
    }
});



module.exports = router;