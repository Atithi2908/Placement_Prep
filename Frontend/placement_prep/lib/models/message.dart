class Message {
  final String groupId; 
  final String senderId;
  final String message;
   
   Message({required this.groupId, required this.message, required this.senderId});
   factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
    message: json['message'],
      senderId: json['senderId'],
      groupId: json['groupId'],
    );
  }


}
