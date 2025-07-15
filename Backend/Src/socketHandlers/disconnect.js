module.exports=(socket, io) => {        
socket.on('disconnect', () => {
  // Mark user as offline in DB or memory
  io.to(groupId).emit('userOffline', { userId: socket.user.id });
})};
