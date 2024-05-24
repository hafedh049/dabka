class ChatHead {
  final String id;
  final DateTime timestamp;
  final String remoteName;
  final String remoteID;
  final String remoteImage;
  final String lastMessage;
  final bool yourMessage;

  ChatHead({
    required this.id,
    required this.timestamp,
    required this.remoteName,
    required this.remoteID,
    required this.remoteImage,
    required this.lastMessage,
    required this.yourMessage,
  });

  ChatHead.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'].toDate(),
        remoteName = json['remoteName'],
        id = json['id'],
        remoteID = json['remoteID'],
        remoteImage = json['remoteImage'],
        lastMessage = json['lastMessage'],
        yourMessage = json['yourMessage'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'timestamp': timestamp,
        'remoteName': remoteName,
        'id': id,
        'remoteID': remoteID,
        'remoteImage': remoteImage,
        'lastMessage': lastMessage,
        'yourMessage': yourMessage,
      };
}
