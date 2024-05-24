import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/message_model.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

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

  List<MessageModel> _messages = <MessageModel>[];

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final String messageID = const Uuid().v8();
    final Timestamp now = Timestamp.now();

    await Future.wait(
      <Future>[
        FirebaseFirestore.instance.collection('messages').doc(messageID).set(
              MessageModel(
                messageID: messageID,
                roomID: widget.chatHead.roomID,
                message: _messageController.text.trim(),
                timestamp: now.toDate(),
                senderID: FirebaseAuth.instance.currentUser!.uid,
                receiverID: widget.chatHead.remoteID,
                type: "text",
              ).toJson(),
            ),
        FirebaseFirestore.instance.collection('chat_heads').doc(widget.chatHead.roomID).update(
              ChatHead(
                roomID: widget.chatHead.roomID,
                timestamp: now.toDate(),
                remoteName: widget.chatHead.remoteName,
                remoteID: widget.chatHead.remoteID,
                remoteImage: widget.chatHead.remoteImage,
                lastMessage: _messageController.text.trim(),
                lastMessageType: "text",
              ).toJson(),
            ),
      ],
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: 300.ms,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatHead.remoteName, style: GoogleFonts.abel(color: white, fontSize: 16, fontWeight: FontWeight.w500)),
        backgroundColor: white,
        elevation: 8,
        shadowColor: dark,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('messages').where('roomID', isEqualTo: widget.chatHead.roomID).orderBy('timestamp', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Wait();
                } else if (snapshot.hasError) {
                  return ErrorScreen(error: snapshot.error.toString());
                } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                        Text("No Categories Yet!", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  );
                }

                _messages = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => MessageModel.fromJson(doc.data())).toList();
                return ListView.separated(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _messages.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final MessageModel message = _messages[index];
                    final messageWidget = _buildMessage(message);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: messageWidget,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: GoogleFonts.abel(color: grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: grey,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: purple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessage(MessageModel message) {
    final messageText = message.message;
    final messageTime = message.timestamp;

    return Row(
      mainAxisAlignment: message.senderID == FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (message.senderID != FirebaseAuth.instance.currentUser!.uid)
          CircleAvatar(
            backgroundImage: AssetImage(widget.chatHead.remoteImage),
            radius: 15,
          ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: message.senderID == FirebaseAuth.instance.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              decoration: BoxDecoration(
                color: message.senderID == FirebaseAuth.instance.currentUser!.uid ? purple : grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                messageText,
                style: GoogleFonts.abel(color: message.senderID == FirebaseAuth.instance.currentUser!.uid ? white : dark),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatDate(messageTime, const <String>[dd, '/', mm, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]),
              style: GoogleFonts.abel(color: grey, fontSize: 10),
            ),
          ],
        ),
        if (message.senderID == FirebaseAuth.instance.currentUser!.uid) const SizedBox(width: 8),
        if (message.senderID == FirebaseAuth.instance.currentUser!.uid)
          CircleAvatar(
            backgroundImage: AssetImage(widget.chatHead.remoteImage),
            radius: 15,
          ),
      ],
    );
  }
}
