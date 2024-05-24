// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/true_view_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/product.dart';
import 'package:dabka/views/supplier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:scrolling_text/scrolling_text.dart';
import 'package:video_player/video_player.dart';

import '../../models/user_model.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';

class ViewSpace extends StatefulWidget {
  const ViewSpace({super.key, required this.views, required this.currentIndex});
  final List<TrueViewModel> views;
  final int currentIndex;
  @override
  State<ViewSpace> createState() => _ViewSpaceState();
}

class _ViewSpaceState extends State<ViewSpace> {
  final List<VideoPlayerController> _videoPlayers = <VideoPlayerController>[];
  final List<GlobalKey<State<StatefulWidget>>> _videoKeys = <GlobalKey<State<StatefulWidget>>>[];

  late final PageController _trueViewController;

  String _formatDuration(int durationInSeconds) {
    final int minutes = durationInSeconds ~/ 60;
    final int seconds = durationInSeconds % 60;

    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(0)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(0)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    } else {
      return number.toString();
    }
  }

  @override
  void dispose() {
    _trueViewController.dispose();

    for (final VideoPlayerController player in _videoPlayers) {
      player.removeListener(() {});
      player.dispose();
    }
    _videoPlayers.clear();
    super.dispose();
  }

  UserModel? _user;
  DocumentSnapshot<Map<String, dynamic>>? _userDoc;
  final List<ProductModel> _products = <ProductModel>[];

  Future<bool> _load() async {
    try {
      _videoPlayers.clear();
      for (int index = 0; index < widget.views.length; index++) {
        _videoKeys.add(GlobalKey<State<StatefulWidget>>());
        _videoPlayers.add(VideoPlayerController.networkUrl(Uri.parse(widget.views[index].reelUrl.path)));
        await _videoPlayers[index].initialize();
        _videoPlayers[index].addListener(
          () {
            if (_videoPlayers[index].value.isPlaying) {
              _videoKeys[index].currentState!.setState(() {});
            } else if (_videoPlayers[index].value.isCompleted) {
              _trueViewController.nextPage(duration: 300.ms, curve: Curves.linear);
            }
          },
        );
      }
      _trueViewController = PageController(initialPage: widget.currentIndex);
      _userDoc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      _user = UserModel.fromJson(_userDoc!.data()!);
      _products.clear();
      for (final TrueViewModel view in widget.views) {
        final DocumentSnapshot<Map<String, dynamic>> productDoc = await FirebaseFirestore.instance.collection("products").doc(view.productID).get();
        _products.add(ProductModel.fromJson(productDoc.data()!));
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _load(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return PageView.builder(
              onPageChanged: (int value) {
                _videoPlayers[value - 1].pause();
                _videoPlayers[value].play();
              },
              scrollDirection: Axis.vertical,
              controller: _trueViewController,
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        if (_videoPlayers[index].value.isPlaying) {
                          await _videoPlayers[index].pause();
                        } else {
                          await _videoPlayers[index].play();
                        }
                      },
                      child: VideoPlayer(_videoPlayers[index]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              TextButton.icon(
                                onPressed: () => Navigator.pop(context),
                                label: const Icon(FontAwesome.chevron_left_solid, size: 25, color: white),
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                  backgroundColor: WidgetStateProperty.all<Color>(purple.withOpacity(.4)),
                                  padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(8)),
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () => Navigator.pop(context),
                                label: const Icon(FontAwesome.heart, size: 25, color: white),
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                  backgroundColor: WidgetStateProperty.all<Color>(purple.withOpacity(.4)),
                                  padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(8)),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: <Widget>[
                              const Icon(FontAwesome.caret_right_solid, size: 15, color: white),
                              const SizedBox(width: 5),
                              Text(_formatDuration(_videoPlayers[index].value.duration.inSeconds), style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white)),
                              const SizedBox(width: 10),
                              const Icon(FontAwesome.eye_solid, size: 12, color: white),
                              const SizedBox(width: 5),
                              Text(_formatNumber(widget.views[index].reelViews), style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width * .7,
                                      height: 20,
                                      child: ScrollingText(
                                        text: widget.views[index].package,
                                        onFinish: () {},
                                        textStyle: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text("Price : ${widget.views[index].price.toStringAsFixed(3)} TND", style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.bold, color: white)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  await _videoPlayers[index].pause();
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Product(product: _products[index])));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    gradient: LinearGradient(colors: <Color>[blue.withOpacity(.6), pink.withOpacity(.6)]),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      gradient: LinearGradient(colors: <Color>[blue.withOpacity(.6), pink.withOpacity(.6)]),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        gradient: LinearGradient(colors: <Color>[blue.withOpacity(.6), pink.withOpacity(.6)]),
                                      ),
                                      child: Text("View Product", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Supplier(supplier: _user!))),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: _user!.userAvatar.isEmpty
                                        ? DecorationImage(
                                            image: AssetImage("assets/images/${_user!.gender == 'M' ? 'n' : 'f'}obody.png"),
                                            fit: BoxFit.contain,
                                          )
                                        : DecorationImage(
                                            image: CachedNetworkImageProvider(_user!.userAvatar),
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(_user!.username, style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white)),
                                    const SizedBox(height: 5),
                                    Text("${_user!.followers} Followers", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (_user!.userID != FirebaseAuth.instance.currentUser!.uid)
                                GestureDetector(
                                  onTap: () async {},
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      gradient: LinearGradient(colors: <Color>[white.withOpacity(.8), pink.withOpacity(.8)]),
                                    ),
                                    child: Text("Follow", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          StatefulBuilder(
                            key: _videoKeys[index],
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(!_videoPlayers[index].value.isInitialized ? "" : _formatDuration(_videoPlayers[index].value.position.inSeconds), style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                                  const SizedBox(height: 5),
                                  AnimatedContainer(
                                    duration: 100.ms,
                                    height: 5,
                                    decoration: BoxDecoration(color: blue.withOpacity(!_videoPlayers[index].value.isInitialized ? 0 : _videoPlayers[index].value.position.inSeconds / _videoPlayers[index].value.duration.inSeconds), borderRadius: BorderRadius.circular(3)),
                                    width: !_videoPlayers[index].value.isInitialized ? 0 : _videoPlayers[index].value.position.inSeconds * ((MediaQuery.of(context).size.width - 16 * 2) / _videoPlayers[index].value.duration.inSeconds),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: widget.views.length,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Wait();
          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
