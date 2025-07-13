const Group = require('../models/Group');
const Candidate = require('../models/Candidate');

const createGroup = async (req, res) => {
    const {name,description} = req.body;
    const userId = req.user.id;
    try{
        const newGroup = await Group.create({
         name,
         description,
         members:[ userId ],
         admins:[ userId ]

        });
        await Candidate.findByIdAndUpdate(userId, {
            $push: { joinedGroups: newGroup._id },
           
        });
        res.status(201).json({ group: newGroup });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' }); 
    }
};

const getGroups = async (req,res)=> {
    console.log("Get groups for user called");
    const userId = req.user.groupId;
    try {
       const groups = await Candidate.findById(userId).select('-password').populate('joinedGroups');
       res.status(200).json(groups);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

const getGroupDetails = async (req, res) => {
    const groupId = req.query.groupId;
    console.log(`Fetching details for group ID: ${groupId}`);
    try {
        const group = await Group.findById(groupId).populate('members', 'name email');
        if (!group) {
            return res.status(404).json({ message: 'Group not found' });
        }
        console.log(group);
        res.status(200).json(group);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

const joinGroup = async (req, res) => {
    const groupId = req.query.groupId;
    const userId = req.user.id;
    try {
        const group = await Group.findById(groupId);
        if (!group) {
            return res.status(404).json({ message: 'Group not found' });
        }
        if (group.members.includes(userId)) {
            return res.status(400).json({ message: 'Already a member of the group' });
        }
        group.members.push(userId);
        await group.save();
            await Candidate.findByIdAndUpdate(userId, {
      $addToSet: { joinedGroups: group._id }
    });
        res.status(200).json({ message: 'Joined group successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

const leaveGroup = async (req, res) => {
    const groupId = req.query.groupId;
    const userId = req.user.id;
    try {
        const group = await Group.findById(groupId);
        if (!group) {
            return res.status(404).json({ message: 'Group not found' });
        }
        if (!group.members.includes(userId)) {
            return res.status(400).json({ message: 'Not a member of the group' });
        }
        group.members.pull(userId);
        await group.save();
        await Candidate.findByIdAndUpdate(userId, {
            $pull: { joinedGroups: group._id }
        });
        res.status(200).json({ message: 'Left group successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
}

module.exports = {
    createGroup,
    getGroups,
    getGroupDetails,
    joinGroup,
    leaveGroup
};