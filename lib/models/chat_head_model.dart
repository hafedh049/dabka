class ChatHead {
  final String roomID;
  final DateTime timestamp;
  final String remoteName;
  final String remoteImage;
  final String lastMessage;
  final String lastMessageType;
  final bool yourMessage;

  ChatHead({
    required this.roomID,
    required this.timestamp,
    required this.remoteName,
    required this.remoteImage,
    required this.lastMessage,
    required this.lastMessageType,
    required this.yourMessage,
  });

  factory ChatHead.fromJson(Map<String, dynamic> json) {
    return ChatHead(
      roomID: json['roomID'],
      timestamp: json['timestamp'].toDate(),
      remoteName: json['remoteName'],
      remoteImage: json['remoteImage'],
      lastMessage: json['lastMessage'],
      lastMessageType: json['lastMessageType'],
      yourMessage: json['yourMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomID': roomID,
      'timestamp': timestamp,
      'remoteName': remoteName,
      'remoteImage': remoteImage,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType, // Added this line
      'yourMessage': yourMessage,
    };
  }
}
