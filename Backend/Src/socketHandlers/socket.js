const joinGroupHandler = require('./joinGroup');
const sendMessageHandler = require('./sendMessage');
const disconnectHandler = require('./disconnect');

module.exports = (socket, io) => {
  joinGroupHandler(socket, io);
  sendMessageHandler(socket, io);
  disconnectHandler(socket, io);
};

