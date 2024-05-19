import 'package:dabka/models/chat_head_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/helpers/error.dart';
import '../../../utils/helpers/wait.dart';
import '../../../utils/shared.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});
  @override
  State<ChatsList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatsList> {
  List<ChatHead> _chats = <ChatHead>[];

  Future<List<ChatHead>> _load() async {
    try {
      return <ChatHead>[];
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Old Chats", style: GoogleFonts.abel(color: dark, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: FutureBuilder(
            future: _load(),
            builder: (BuildContext context, AsyncSnapshot<List<ChatHead>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                _chats = snapshot.data!;
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
              } else if (snapshot.hasData == snapshot.data!.isEmpty) {
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
