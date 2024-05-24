import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/auth/sign_in.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/chat_head_model.dart';
import '../../../utils/helpers/error.dart';
import '../../../utils/helpers/wait.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<ChatHead> _chats = <ChatHead>[];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          shadowColor: dark,
          elevation: 6,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Card(
                  shadowColor: dark,
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: white),
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
                const SizedBox(width: 10),
                Text("Connect with support", style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FirebaseAuth.instance.currentUser == null
            ? InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn(passed: true))),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                  child: Text("Sign in", style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              )
            : Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("chat_heads").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      _chats = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ChatHead.fromJson(e.data())).toList();
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) => Card(
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
                                    Text(_chats[index].remoteName, style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
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
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                        itemCount: _chats.length,
                      );
                    } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Old Chats", style: GoogleFonts.abel(color: dark, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Image.asset("assets/images/empty_chat.png", color: purple),
                            const SizedBox(height: 20),
                            Text(
                              "Please be aware that we will do as much as we can to help you and tha we care for your experience with us feel free to contact us and thank you.",
                              style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
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
