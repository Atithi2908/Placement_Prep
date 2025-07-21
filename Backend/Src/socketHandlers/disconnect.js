module.exports=(socket, io) => {        
socket.on('disconnect', () => {
  // Mark user as offline in DB or memory
})};
