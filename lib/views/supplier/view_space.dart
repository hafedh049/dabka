// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/true_view_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/product.dart';
import 'package:dabka/views/supplier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:scrolling_text/scrolling_text.dart';
import 'package:video_player/video_player.dart';

import '../../models/user_model.dart';
import '../../utils/callbacks.dart';
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
  PageController _trueViewController = PageController();

  final List<ProductModel> _products = <ProductModel>[];
  final List<UserModel> _users = <UserModel>[];

  Future<bool> _load() async {
    try {
      _trueViewController = PageController(initialPage: widget.currentIndex);
      _users.clear();
      _products.clear();
      for (final TrueViewModel view in widget.views) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection("users").doc(view.userID).get();
        _users.add(UserModel.fromJson(userDoc.data()!));
        final DocumentSnapshot<Map<String, dynamic>> productDoc = await FirebaseFirestore.instance.collection("products").doc(view.productID).get();
        _products.add(ProductModel.fromJson(productDoc.data()!));
      }
      return true;
    } catch (e) {
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
              scrollDirection: Axis.vertical,
              controller: _trueViewController,
              itemBuilder: (BuildContext context, int index) {
                return VideoTemplate(
                  callback: () async => await _trueViewController.nextPage(duration: 200.milliseconds, curve: Curves.linear),
                  trueView: widget.views[index],
                  product: _products[index],
                  user: _users[index],
                );
              },
              itemCount: widget.views.length,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Wait();
          } else {
            debugPrint(snapshot.error.toString());
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}

class VideoTemplate extends StatefulWidget {
  const VideoTemplate({super.key, required this.callback, required this.trueView, required this.product, required this.user});
  final TrueViewModel trueView;
  final ProductModel product;
  final UserModel user;
  final void Function() callback;
  @override
  State<VideoTemplate> createState() => _VideoTemplateState();
}

class _VideoTemplateState extends State<VideoTemplate> {
  late final VideoPlayerController _playerController;
  final GlobalKey<State<StatefulWidget>> _durationKey = GlobalKey<State<StatefulWidget>>();
  @override
  void initState() {
    _playerController = VideoPlayerController.networkUrl(Uri.parse(widget.trueView.reelUrl.path));
    super.initState();
  }

  @override
  void dispose() {
    if (_playerController.value.isPlaying) {
      _playerController.pause();
    }
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              if (_playerController.value.isPlaying) {
                await _playerController.pause();
              } else {
                await _playerController.play();
              }
            },
            child: FutureBuilder<void>(
              future: _playerController.initialize(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  _playerController.addListener(
                    () {
                      if (_playerController.value.isPlaying) {
                        _durationKey.currentState!.setState(() {});
                      } else if (_playerController.value.isCompleted) {
                        widget.callback();
                      }
                    },
                  );
                  Future.delayed(1.seconds, () async => await _playerController.play());
                  return VideoPlayer(_playerController);
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Wait(switcher: true);
                }
                return ErrorScreen(error: snapshot.error.toString());
              },
            ),
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
                    Text(formatDuration(_playerController.value.duration.inSeconds), style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white)),
                    const SizedBox(width: 10),
                    const Icon(FontAwesome.eye_solid, size: 12, color: white),
                    const SizedBox(width: 5),
                    Text(formatNumber(widget.trueView.reelViews), style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white)),
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
                              text: "EXCLUSIVE PACKAGE FOR THIS PRODUCT ON CATEGORY : ${widget.trueView.category}",
                              onFinish: () {},
                              textStyle: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text("${'Price'.tr} : ${(Random().nextInt(1000) * Random().nextDouble()).toStringAsFixed(3)} " "TND".tr, style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.bold, color: white)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await _playerController.pause();
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Product(product: widget.product)));
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
                            child: Text("View Product".tr, style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Supplier(supplier: widget.user))),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: widget.user.userAvatar.isEmpty
                              ? DecorationImage(
                                  image: AssetImage("assets/images/${widget.user.gender == 'M' ? 'n' : 'f'}obody.png"),
                                  fit: BoxFit.contain,
                                )
                              : DecorationImage(
                                  image: CachedNetworkImageProvider(widget.user.userAvatar),
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
                          Text(widget.user.username, style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: white)),
                          const SizedBox(height: 5),
                          Text("${widget.user.followers} ${'Followers'.tr}", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (FirebaseAuth.instance.currentUser == null || widget.user.userID != FirebaseAuth.instance.currentUser!.uid)
                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(colors: <Color>[white.withOpacity(.8), pink.withOpacity(.8)]),
                          ),
                          child: Text("Follow".tr, style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  key: _durationKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(!_playerController.value.isInitialized ? "" : formatDuration(_playerController.value.position.inSeconds), style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: white)),
                        const SizedBox(height: 5),
                        AnimatedContainer(
                          duration: 100.milliseconds,
                          height: 5,
                          decoration: BoxDecoration(color: blue.withOpacity(!_playerController.value.isInitialized ? 0 : _playerController.value.position.inSeconds / _playerController.value.duration.inSeconds), borderRadius: BorderRadius.circular(3)),
                          width: !_playerController.value.isInitialized ? 0 : _playerController.value.position.inSeconds * ((MediaQuery.of(context).size.width - 16 * 2) / _playerController.value.duration.inSeconds),
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
    );
  }
}
