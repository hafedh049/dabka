import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeAdsCarousel extends StatefulWidget {
  const HomeAdsCarousel({super.key, required this.images});
  final List<String> images;
  @override
  State<HomeAdsCarousel> createState() => _HomeAdsCarouselState();
}

class _HomeAdsCarouselState extends State<HomeAdsCarousel> {
  final PageController _imagesController = PageController();

  late final Timer _imageTimer;

  int _currentImagePage = 0;

  final GlobalKey<State<StatefulBuilder>> _smoothKey = GlobalKey<State<StatefulBuilder>>();

  @override
  void initState() {
    _imageTimer = Timer.periodic(1.seconds, (Timer _) => _imagesController.jumpTo((_currentImagePage++ % widget.images.length).toDouble()));
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
    return Column(
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
