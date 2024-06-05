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

import '../../utils/callbacks.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';
import '../../utils/shared.dart';

class ViewsList extends StatefulWidget {
  const ViewsList({super.key});

  @override
  State<ViewsList> createState() => _ViewsListState();
}

class _ViewsListState extends State<ViewsList> {
  List<TrueViewModel> _views = <TrueViewModel>[];
  List<VideoPlayerController> _videosControllers = <VideoPlayerController>[];

  @override
  void dispose() {
    for (final VideoPlayerController controller in _videosControllers) {
      controller.dispose();
    }
    _videosControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _views = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => TrueViewModel.fromJson(e.data())).toList();
                _videosControllers = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => VideoPlayerController.networkUrl(Uri.parse(e.get("reelUrl")["path"]))..initialize()).toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: .6,
                  ),
                  itemCount: _views.length,
                  itemBuilder: (BuildContext context, index) => InkWell(
                    hoverColor: transparent,
                    splashColor: transparent,
                    highlightColor: transparent,
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
                              Text("Are you sure ?".tr, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance.collection("true_views").doc(_views[index].reelID).delete();
                                      showToast(context, "True View deleted successfully".tr);
                                      Navigator.pop(context);
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
                      );
                    },
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ViewSpace(
                          views: <TrueViewModel>[for (final TrueViewModel trueView in _views) trueView],
                          currentIndex: index,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: <Widget>[
                          VideoPlayer(_videosControllers[index]),
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
                                      child: Text(_views[index].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
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
                                    Text(_views[index].userName, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
