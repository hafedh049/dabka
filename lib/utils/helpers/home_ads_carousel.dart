import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeAdsCarousel extends StatefulWidget {
  const HomeAdsCarousel({super.key, required this.images});
  final List<String> images;
  @override
  State<HomeAdsCarousel> createState() => _HomeAdsCarouselState();
}

class _HomeAdsCarouselState extends State<HomeAdsCarousel> {
  final PageController _imagesController = PageController();

  Timer _imageTimer = Timer(1.seconds, () {});

  int _currentImagePage = 0;

  final GlobalKey<State<StatefulBuilder>> _smoothKey = GlobalKey<State<StatefulBuilder>>();

  @override
  void initState() {
    if (widget.images.length > 1) {
      _imageTimer = Timer.periodic(1.seconds, (Timer _) => _imagesController.jumpTo((_currentImagePage++ % widget.images.length).toDouble()));
    }
    super.initState();
  }

  @override
  void dispose() {
    _imagesController.dispose();
    _imageTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.images.isEmpty
        ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PageView.builder(
                onPageChanged: (int page) => _smoothKey.currentState!.setState(() {}),
                scrollDirection: Axis.horizontal,
                controller: _imagesController,
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int index) => Image.asset(
                  "assets/images/${widget.images[index]}",
                  width: MediaQuery.sizeOf(context).width - 2 * 16,
                  height: 250,
                ),
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                key: _smoothKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return SmoothPageIndicator(
                    controller: _imagesController,
                    count: widget.images.length,
                    onDotClicked: (int dot) => _imagesController.jumpToPage(dot),
                  );
                },
              ),
            ],
          );
  }
}
