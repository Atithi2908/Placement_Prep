const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/auth.middleware');
const {
    createGroup,
    getGroups,
    getGroupDetails,
    joinGroup,
    leaveGroup
} = require('../controllers/Group.controller');

router.post('/create', authMiddleware, createGroup);
router.get('/getGroups', authMiddleware, getGroups);
router.get('/getUsers', authMiddleware, getGroupDetails);
router.post('/join', authMiddleware, joinGroup);
router.post('/leave', authMiddleware, leaveGroup);

module.exports = router;