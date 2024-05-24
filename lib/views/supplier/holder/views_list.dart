// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/true_view_model.dart';
import 'package:dabka/views/supplier/holder/add_view.dart';
import 'package:dabka/views/supplier/holder/view_space.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:shadow_overlay/shadow_overlay.dart';
import 'package:video_player/video_player.dart';

import '../../../models/user_model.dart';
import '../../../utils/helpers/error.dart';
import '../../../utils/helpers/wait.dart';
import '../../../utils/shared.dart';

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
            Text("True Views List", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddTrueView(
                    user: UserModel(
                      userID: "1",
                      email: "1",
                      password: "1",
                      phoneNumber: "1",
                      username: "1",
                      categoryName: "1",
                      categoryID: "1",
                      userAvatar: "1",
                      userType: ["1"],
                      userDescription: "1",
                      followers: 1,
                      gender: "M",
                    ),
                  ),
                ),
              ),
              icon: const Icon(FontAwesome.circle_plus_solid, color: purple, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("true_views").where("userID", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                _views = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => TrueViewModel.fromJson(e.data())).toList(); // _splitTrueViews(snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => TrueViewModel.fromJson(e.data())).toList());
                _videosControllers = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => VideoPlayerController.networkUrl(Uri.parse(e.get("reelUrl")["path"]))..initialize()).toList(); //_splitVideoControllers(snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => VideoPlayerController.networkUrl(Uri.parse(e.get("reelUrl")["path"]))..initialize()).toList());
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
                                Text(_views[index].package, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Text("${_views[index].price.toStringAsFixed(2).replaceAll(".", ",")} DT", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
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
                ); /* ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) => Row(
                    children: <Widget>[
                      InkWell(
                        hoverColor: transparent,
                        splashColor: transparent,
                        highlightColor: transparent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ViewSpace(
                              views: <TrueViewModel>[
                                for (final List<TrueViewModel> list in _views)
                                  for (final TrueViewModel trueView in list) trueView
                              ],
                              currentIndex: index,
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: (MediaQuery.sizeOf(context).width - 2 * 8) / 2 - 20,
                            height: 250,
                            child: Stack(
                              children: <Widget>[
                                VideoPlayer(_videosControllers[index].first),
                                ShadowOverlay(
                                  shadowHeight: 150,
                                  shadowWidth: (MediaQuery.sizeOf(context).width - 2 * 8) / 2 - 20,
                                  shadowColor: pink.withOpacity(.6),
                                  child: Container(
                                    width: (MediaQuery.sizeOf(context).width - 2 * 8) / 2 - 20,
                                    height: 250,
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
                                            child: Text(_views[index][0].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(_views[index][0].package, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text("${_views[index][0].price.toStringAsFixed(2).replaceAll(".", ",")} DT", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: <Widget>[
                                          const CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/images/logo.png')),
                                          const SizedBox(width: 10),
                                          Text(_views[index][0].userName, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_views[index].length > 1) ...<Widget>[
                        const SizedBox(width: 20),
                        InkWell(
                          hoverColor: transparent,
                          splashColor: transparent,
                          highlightColor: transparent,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ViewSpace(
                                views: <TrueViewModel>[
                                  for (final List<TrueViewModel> list in _views)
                                    for (final TrueViewModel trueView in list) trueView
                                ],
                                currentIndex: index + 1,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: (MediaQuery.sizeOf(context).width - 2 * 8) / 2 - 20,
                              height: 250,
                              child: Stack(
                                children: <Widget>[
                                  VideoPlayer(_videosControllers[index].last),
                                  ShadowOverlay(
                                    shadowHeight: 150,
                                    shadowWidth: (MediaQuery.sizeOf(context).width - 2 * 8) / 2 - 20,
                                    shadowColor: pink,
                                    child: Container(
                                      width: (MediaQuery.sizeOf(context).width - 2 * 8) / 2 - 20,
                                      height: 250,
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
                                              child: Text(_views[index][1].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(_views[index][1].category, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Text("${_views[index][1].price.toStringAsFixed(2).replaceAll(".", ",")} DT", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            const CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/images/logo.png')),
                                            const SizedBox(width: 10),
                                            Text(_views[index][1].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                  itemCount: _views.length,
                );*/
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                      Text("No True Views Yet!", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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
