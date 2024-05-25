import 'dart:async';
import 'dart:convert';

import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeAdsCarousel extends StatefulWidget {
  const HomeAdsCarousel({super.key});
  @override
  State<HomeAdsCarousel> createState() => _HomeAdsCarouselState();
}

class _HomeAdsCarouselState extends State<HomeAdsCarousel> {
  final PageController _imagesController = PageController();

  Timer? _imageTimer;

  int _currentImagePage = 0;

  final GlobalKey<State<StatefulBuilder>> _smoothKey = GlobalKey<State<StatefulBuilder>>();

  List<String> _images = <String>[];

  @override
  void initState() {
    _imageTimer = Timer.periodic(
      3.seconds,
      (Timer _) {
        if (_images.isNotEmpty) {
          _imagesController.animateToPage(_currentImagePage++ % _images.length, curve: Curves.linear, duration: 500.ms);
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _imagesController.dispose();
    if (_imageTimer != null) {
      _imageTimer!.cancel();
    }
    super.dispose();
  }

  Future<List<String>> _load() async {
    return jsonDecode(await rootBundle.loadString("assets/jsons/ads.json")).cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _load(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          _images = snapshot.data!;
          return _images.isEmpty
              ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
              : Center(
                  child: SizedBox(
                    height: 130,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: PageView.builder(
                            onPageChanged: (int page) => _smoothKey.currentState!.setState(() {}),
                            scrollDirection: Axis.horizontal,
                            controller: _imagesController,
                            itemCount: _images.length,
                            itemBuilder: (BuildContext context, int index) => ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                _images[index],
                                width: MediaQuery.sizeOf(context).width - 2 * 16,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        StatefulBuilder(
                          key: _smoothKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return SmoothPageIndicator(
                              controller: _imagesController,
                              count: _images.length,
                              effect: const WormEffect(dotHeight: 5, activeDotColor: purple),
                              onDotClicked: (int dot) => _imagesController.jumpToPage(dot),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
