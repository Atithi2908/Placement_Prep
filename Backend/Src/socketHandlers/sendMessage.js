module.exports = (socket, io) => {
  socket.on('sendMessage', ({ groupId, message }) => {
    const { id } = socket.user;

    if (!groupId || !message) return;

    console.log(`💬 ${id} sent a message to ${groupId}: ${message}`);

    socket.to(groupId).emit('receiveMessage', {
      userId: id,
      message,
      timestamp: new Date().toISOString()
    });
  });
};
