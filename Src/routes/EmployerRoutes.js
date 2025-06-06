const express = require('express');
const router = express.Router();
const Employer = require('../models/Employer');
const bcrypt = require('bcrypt');
const JWT_SECRET = "atithi@1234";
const jwt = require('jsonwebtoken');

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

router.post('/signup', async (req, res) => {
    const { companyName, companyEmail, employerName,password, phone } = req.body;
    try {
        const existingEmployer = await Employer.findOne({ phone });
        if (existingEmployer) {
            return res.status(400).json({ message: 'Employer already exists' });
        }
        const hashedPassword = await bcrypt.hash(password,10);
        const newEmployer = new Employer({
            companyName: companyName,
            companyEmail:companyEmail,
            employerName:employerName,
            password: hashedPassword,
            phone: phone
        })
        await newEmployer.save();
        res.status(201).json({ message: 'Employer registered successfully' });
    } catch (error) {
        console.error('Error during signup:', error);
        res.status(500).json({ message: 'Internal server error' });
    }});

    router.post('/signin', async (req, res) => {
        const {companyEmail,password}=req.body;
        console.log('Signin request:', req.body);
        try{
            const employer = await Employer.findOne({companyEmail});
            console.log('Employer:', employer);
            if(!employer){
                return res.status(400).json({message:'Employer not found'});
            }
            const isMatch = await bcrypt.compare(password,employer.password);  
            if(!isMatch){
                return res.status(400).json({message:'Invalid credentials'});
            }
            const token = jwt.sign({
                id:employer._id,
                email:employer.companyEmail,
            },JWT_SECRET, {
                expiresIn: '1h'
            });
            res.status(200).json({token, employerId: employer._id,employerName: employer.name});
        }catch(error){  
            console.error('Error during signin:', error);
            res.status(500).json({ message: 'Internal server error' });       
        }});


        router.get('/getdetails', authMiddleware, async (req, res) => {
            try{
                const employer = await Employer.findOne({companyEmail:req.user.email});
                console.log('Email----', req.user.email);
                console.log('Employer details:', employer);
                if(!employer){
                    return res.status(400).json({message:'Employer not found'});
                }
                res.status(200).json({employer});
            }
            catch(error){
                console.error('Error fetching candidate details:', error);
                res.status(500).json({ message: 'Internal server error' });
            }
        });
        module.exports = router;