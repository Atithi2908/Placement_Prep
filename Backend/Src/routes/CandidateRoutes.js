const express = require('express');
const router = express.Router();
const Candidate = require('../models/Candidate');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const JWT_SECRET = "atithi@1234";
const Application = require('../models/Application');
const Job = require('../models/Job');
const authMiddleware = require('../middlewares/auth.middleware');

const {
    signup,
    signin,
    getdetails,
    apply,
    addTasks,
    getTasks,
    markTaskDone,
    markTaskUndone,
    dailyQuestion
} = require('../controllers/Candidate.controller');

router.post('/signup', signup);
router.post('/signin', signin);

router.get('/getdetails', authMiddleware, getdetails);
router.post('/apply', authMiddleware, apply);
router.post('/task/add', authMiddleware, addTasks);
router.get('/task/get', authMiddleware, getTasks);
router.patch('/task/mark-done', authMiddleware, markTaskDone);
router.patch('/task/mark-undone', authMiddleware, markTaskUndone);
router.get('/daily-question',dailyQuestion);

module.exports = router;