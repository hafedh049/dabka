// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/true_view_model.dart';
import 'package:dabka/views/supplier/add_view.dart';
import 'package:dabka/views/supplier/view_space.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:shadow_overlay/shadow_overlay.dart';
import 'package:video_player/video_player.dart';

import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';
import '../../utils/shared.dart';

class ViewsList extends StatefulWidget {
  const ViewsList({super.key});

  @override
  State<ViewsList> createState() => _ViewsListState();
}

class _ViewsListState extends State<ViewsList> {
  @override
  Widget build(BuildContext context) {
    List<TrueViewModel> views = <TrueViewModel>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("True Views List".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddTrueView())),
              icon: const Icon(FontAwesome.circle_plus_solid, color: purple, size: 25),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("true_views").where("userID", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                views = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => TrueViewModel.fromJson(e.data())).toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: .6,
                  ),
                  itemCount: views.length,
                  itemBuilder: (BuildContext context, index) => InkWell(
                    hoverColor: transparent,
                    splashColor: transparent,
                    highlightColor: transparent,
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Scaffold(
                            backgroundColor: white,
                            appBar: AppBar(
                              centerTitle: true,
                              backgroundColor: white,
                              title: Text("Are you sure ?".tr, style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
                              leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 20, color: purple)),
                            ),
                            body: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Card(
                                  shadowColor: dark,
                                  elevation: 8,
                                  color: white,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text("Are you sure ?".tr, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await FirebaseFirestore.instance.collection("true_views").doc(views[index].reelID).delete();
                                                //showToast(context, "True View deleted successfully".tr);
                                              },
                                              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                              child: Text("OK".tr, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.w500)),
                                            ),
                                            const SizedBox(width: 10),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(grey.withOpacity(.3))),
                                              child: Text("CANCEL".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewSpace(views: views, currentIndex: index))),
                    child: TrueViewVideo(trueView: views[index]),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                      Text("No True Views Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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

class TrueViewVideo extends StatefulWidget {
  const TrueViewVideo({super.key, required this.trueView});
  final TrueViewModel trueView;
  @override
  State<TrueViewVideo> createState() => _TrueViewVideoState();
}

class _TrueViewVideoState extends State<TrueViewVideo> {
  late final VideoPlayerController _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.trueView.reelUrl.path));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _controller.initialize(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return VideoPlayer(_controller);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Wait(switcher: true);
              }
              return ErrorScreen(error: snapshot.error.toString());
            },
          ),
          ShadowOverlay(
            shadowHeight: 150,
            shadowWidth: 200,
            shadowColor: pink.withOpacity(.6),
            child: Container(
              width: 200,
              height: 350,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: pink.withOpacity(.8),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(widget.trueView.category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Spacer(),
                Text("EXCLUSIVE PACKAGE", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("${(Random().nextDouble() * Random().nextInt(1000)).toStringAsFixed(2).replaceAll(".", ",")} DT", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    const CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/images/logo.png')),
                    const SizedBox(width: 10),
                    Text(widget.trueView.userName, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
