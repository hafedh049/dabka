import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/auth/sign_in.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_head_model.dart';
import '../../models/message_model.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<State<StatefulWidget>> _firstTimeKey = GlobalKey<State<StatefulWidget>>();
  List<MessageModel> _messages = <MessageModel>[];

  UserModel? _user;

  String _roomID = '';

  bool _firstTime = true;

  Future<bool> _loadUserInfo() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    _user = UserModel.fromJson(userDoc.data()!);
    final QuerySnapshot<Map<String, dynamic>> roomDoc = await FirebaseFirestore.instance.collection("chat_heads").where('remoteID', isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
    if (roomDoc.docs.firstOrNull != null) {
      _roomID = roomDoc.docs.first.get('roomID');
    }

    return true;
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final String message = _messageController.text.trim();
    _messageController.clear();

    final String messageID = const Uuid().v8();
    final Timestamp now = Timestamp.now();

    if (_roomID.isEmpty) {
      _roomID = const Uuid().v8();
    }

    await Future.wait(
      <Future>[
        FirebaseFirestore.instance.collection('messages').doc(messageID).set(
              MessageModel(
                messageID: messageID,
                roomID: _roomID,
                message: message,
                timestamp: now.toDate(),
                senderID: FirebaseAuth.instance.currentUser!.uid,
                receiverID: '4kX5FdxdqjgEVIppH4EqLZBzVLP2',
                type: "text",
              ).toJson(),
            ),
        FirebaseFirestore.instance.collection('chat_heads').doc(_roomID).set(
              ChatHead(
                roomID: _roomID,
                timestamp: now.toDate(),
                remoteName: _user!.username,
                remoteID: _user!.userID,
                remoteImage: _user!.userAvatar,
                lastMessage: message,
                lastMessageType: "text",
              ).toJson(),
            ),
      ],
    );

    _scrollToBottom();

    if (_messages.isNotEmpty) {
      _firstTime = false;
    }

    if (_firstTime) {
      _firstTimeKey.currentState!.setState(() {});
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: 300.milliseconds,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String _formatCustomDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(1.days);
    final dayBeforeYesterday = today.subtract(2.days);

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return '${'Today, at'.tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == yesterday.day) {
      return '${'Yesterday, at'.tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == dayBeforeYesterday.day) {
      return '${'2 days ago, at'.tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else {
      return formatDate(date, const <String>[dd, '/', mm, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    }
  }

  Widget _buildMessage(MessageModel message) {
    final messageText = message.message;
    final messageTime = message.timestamp;

    return Row(
      mainAxisAlignment: message.senderID == FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
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
              _formatCustomDate(messageTime),
              style: GoogleFonts.abel(color: grey, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Center(
            child: InkWell(
              hoverColor: transparent,
              splashColor: transparent,
              highlightColor: transparent,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn(passed: true))),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                child: Text("Sign in".tr, style: GoogleFonts.abel(color: white, fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
          )
        : FutureBuilder<bool>(
            future: _loadUserInfo(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshoted) {
              if (snapshoted.connectionState == ConnectionState.waiting) {
                return const Wait();
              } else if (snapshoted.hasError) {
                return ErrorScreen(error: snapshoted.error.toString());
              }
              return StatefulBuilder(
                key: _firstTimeKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection('messages').where('roomID', isEqualTo: _roomID).orderBy('timestamp', descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Wait();
                      } else if (snapshot.hasError) {
                        return ErrorScreen(error: snapshot.error.toString());
                      }
                      _messages = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => MessageModel.fromJson(doc.data())).toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _messages.isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                                        Text("No Chats Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    reverse: true,
                                    itemCount: _messages.length,
                                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                                    itemBuilder: (BuildContext context, int index) {
                                      final MessageModel message = _messages[index];
                                      final Widget messageWidget = _buildMessage(message);
                                      return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: messageWidget);
                                    },
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Card(
                              shadowColor: dark,
                              elevation: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextField(
                                        controller: _messageController,
                                        decoration: InputDecoration(
                                          hintText: 'Type a message'.tr,
                                          hintStyle: GoogleFonts.abel(color: grey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                                        ),
                                        onSubmitted: (String _) => _sendMessage(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(icon: const Icon(Icons.send, color: purple), onPressed: _sendMessage),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
  }
}
