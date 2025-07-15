
module.exports = (socket,io) => {
  socket.on('joinGroup', ({ groupId}) => {
    const {id} = socket.user; 

    socket.join(groupId); 

    console.log(`${id} joined group ${groupId}`);

    socket.to(groupId).emit('userJoined', { 
      id,
      message: `${id} has joined the group`,
    });
  });

  socket.on('disconnect', () => {
    console.log('❌ Client disconnected:', socket.id);
  });
}