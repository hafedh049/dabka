import 'package:dabka/models/chat_head_model.dart';
import 'package:flutter/material.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key, required this.chats});
  final List<ChatHead> chats;
  @override
  State<ChatsList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );
  }
}
