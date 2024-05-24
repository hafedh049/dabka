import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/chat_head_model.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.chatHead});
  final ChatHead chatHead;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    FirebaseFirestore.instance.collection('messages').add(
      {
        'roomID': widget.chatHead.id,
        'userID': FirebaseAuth.instance.currentUser!.uid,
        'message': _messageController.text.trim(),
        'timestamp': Timestamp.now(),
      },
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatHead.remoteName, style: GoogleFonts.abel(color: white)),
        backgroundColor: white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('messages').where('roomID', isEqualTo: widget.chatHead.id).orderBy('timestamp', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Wait();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return ErrorScreen(error: snapshot.error.toString());
                } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(child: Image.asset("assets/images/empty_chat.png", color: purple));
                }
                final messages = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => doc.data()).toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index];
                    final isMe = message['senderID'] == FirebaseAuth.instance.currentUser!.uid;
                    final messageWidget = _buildMessage(message, isMe);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: messageWidget,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
    final messageText = message['message'] as String;
    final messageTime = (message['timestamp'] as Timestamp).toDate();
    // final formattedTime = DateFormat('hh:mm a').format(messageTime);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
            backgroundImage: AssetImage(widget.chatHead.remoteImage),
            radius: 15,
          ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(
                color: isMe ? Colors.purple : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                messageText,
                style: GoogleFonts.abel(color: isMe ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 4),
            /*Text(
              formattedTime,
              style: GoogleFonts.abel(color: Colors.grey, fontSize: 10),
            ),*/
          ],
        ),
        if (isMe) const SizedBox(width: 8),
        if (isMe)
          CircleAvatar(
            backgroundImage: AssetImage(widget.chatHead.remoteImage),
            radius: 15,
          ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: GoogleFonts.abel(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.purple),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
