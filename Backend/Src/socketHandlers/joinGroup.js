const Group = require('../models/Group');
const Candidate = require('../models/Candidate');
module.exports = (socket,io) => {
  socket.on('joinGroup', async ({ groupId }) => {
  
const { id: userId } = socket.user; 
const group = await Group.findById(groupId);
  
  const alreadyJoined = group.members.includes(userId);
  socket.join(groupId); 
  if (!alreadyJoined) {
     group.members.push(userId);
            await group.save();
                await Candidate.findByIdAndUpdate(userId, {
          $addToSet: { joinedGroups: group._id }
        });
    socket.to(groupId).emit('userJoined', {
      userId,
      message: `${userId} has joined the group`
    });
  }


  console.log(`${userId} joined room ${groupId}`);
});

}