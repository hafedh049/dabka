class MessageModel {
  final String id;
  final String message;
  final DateTime createdAt;
  final String senderId;

  MessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.senderId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      senderId: json['senderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'createdAt': createdAt,
      'senderId': senderId,
    };
  }
}
