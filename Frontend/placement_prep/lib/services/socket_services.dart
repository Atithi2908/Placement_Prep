
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices {
  late IO.Socket _socket;

  IO.Socket get socket => _socket;

  void connect(String uri) {
    _socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket.connect();

    _socket.onConnect((_) => print('✅ Socket connected'));
    _socket.onDisconnect((_) => print('❌ Socket disconnected'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
  }
  void disconnect() {
    _socket.disconnect();
  }
    void joinGroup(String groupId) {
    _socket.emit('join_group', {'groupId': groupId});
  }
  void leaveGroup(String groupId) {
    _socket.emit('leave_group', {'groupId': groupId});
  }
  void sendMessage(String message, String groupId) {
    _socket.emit('send_message', {'message': message, 'groupId': groupId});
  }


}