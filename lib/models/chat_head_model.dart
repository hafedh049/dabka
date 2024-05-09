import 'package:flutter/material.dart';

@immutable
class ChatHead {
  final DateTime timestamp;
  final String remoteName;
  final String remoteID;
  final String remoteImage;
  final String lastMessage;
  final bool yourMessage;

  ChatHead({required this.timestamp, required this.remoteName, required this.remoteID, required this.remoteImage, required this.lastMessage, required this.yourMessage});

  ChatHead.fromJson(Map<String, dynamic> json)
      : timestamp = DateTime.parse(json['timestamp']),
        remoteName = json['remoteName'],
        remoteID = json['remoteID'],
        remoteImage = json['remoteImage'],
        lastMessage = json['lastMessage'],
        yourMessage = json['yourMessage'];
}
