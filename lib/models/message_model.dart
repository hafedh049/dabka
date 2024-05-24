class MessageModel {
  final String messageID;
  final String roomID;
  final String message;
  final DateTime timestamp;
  final String senderID;
  final String receiverID;
  final bool isMe;
  final String type;

  MessageModel({
    required this.messageID,
    required this.roomID,
    required this.message,
    required this.timestamp,
    required this.senderID,
    required this.receiverID,
    required this.isMe,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageID: json['messageID'],
      roomID: json['roomID'],
      message: json['message'],
      timestamp: json['timestamp'].toDate(),
      senderID: json['senderID'],
      receiverID: json['receiverID'],
      isMe: json['isMe'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'roomID': roomID,
      'message': message,
      'timestamp': timestamp,
      'senderID': senderID,
      'receiverID': receiverID,
      'isMe': isMe,
      'type': type,
    };
  }
}
