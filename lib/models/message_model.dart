class MessageModel {
  final String id;
  final String message;
  final DateTime createdAt;
  final String senderId;
  final String receiverId; // Add receiverId field
  final bool isMe;
  final String type;

  MessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.senderId,
    required this.receiverId, // Include receiverId in constructor
    required this.isMe,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      senderId: json['senderId'],
      receiverId: json['receiverId'], // Parse receiverId from JSON
      isMe: json['isMe'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'senderId': senderId,
      'receiverId': receiverId, // Include receiverId in JSON
      'isMe': isMe,
      'type': type,
    };
  }
}
