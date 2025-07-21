const Message = require('../models/Message');

module.exports = (socket, io) => {
  socket.on('sendMessage', async({ groupId, message }) => {
    const { id: userId } = socket.user;

    if (!groupId || !message) return;
    const newMessage = new Message({
      groupId,
      senderId: userId,
      message: message
    });

    await newMessage.save();

    console.log(`💬 ${userId} sent a message to ${groupId}: ${message}`);

    socket.to(groupId).emit('receiveMessage', {
      userId: userId,
      message,
      timestamp: new Date().toISOString()
    });
  });
};
