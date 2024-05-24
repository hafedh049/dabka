class MessageModel {
  final String id;
  final String roomID;
  final String message;
  final DateTime createdAt;
  final String senderId;
  final String type;

  MessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.senderId,
    required this.type,
    required this.roomID,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      createdAt: json['createdAt'].toDate(),
      senderId: json['senderId'],
      type: json['type'],
      roomID: json['roomID'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'senderId': senderId,
      'roomID': roomID,
      'type': type,
    };
  }
}
