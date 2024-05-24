// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/chat_head_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/callbacks.dart';
import '../../../utils/helpers/error.dart';
import '../../../utils/helpers/wait.dart';
import '../../../utils/shared.dart';
import 'chat_room.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});
  @override
  State<ChatsList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatsList> {
  List<ChatHead> _chats = <ChatHead>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Old Chats", style: GoogleFonts.abel(color: dark, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('chat_heads').orderBy('timestamp', descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                _chats = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ChatHead.fromJson(e.data())).toList();
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatRoom(chatHead: _chats[index]))),
                    onLongPress: () {
                      showBottomSheet(
                        context: context,
                        builder: (BuildContext context) => Container(
                          color: white,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Are you sure you want to delete this chat ?", style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance.collection("chat_heads").doc(snapshot.data!.docs[index].id).delete();
                                      showToast(context, "Chat deleted successfully");
                                      Navigator.pop(context);
                                    },
                                    style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                    child: Text("OK", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.w500)),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(grey.withOpacity(.3))),
                                    child: Text("CANCEL", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shadowColor: dark,
                      elevation: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white,
                                image: DecorationImage(image: AssetImage(_chats[index].remoteImage), fit: BoxFit.contain),
                                border: Border.all(width: 2, color: purple),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("${_chats[index].yourMessage ? 'You: ' : ''}${_chats[index].remoteName}", style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Flexible(child: Text(_chats[index].lastMessage, style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 10, fontWeight: FontWeight.w500))),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: purple),
                                      child: Text(formatDate(_chats[index].timestamp, const <String>[HH, ":", nn, ":", am]), style: GoogleFonts.abel(color: white, fontSize: 8, fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                  itemCount: _chats.length,
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(child: Image.asset("assets/images/empty_chat.png", color: purple));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Wait();
              } else {
                return ErrorScreen(error: snapshot.error.toString());
              }
            },
          ),
        ),
      ],
    );
  }
}
