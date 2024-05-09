import 'dart:async';

import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Timer? _imageTimer;

  int _currentImagePage = 0;

  final GlobalKey<State<StatefulBuilder>> _smoothKey = GlobalKey<State<StatefulBuilder>>();

  @override
  void initState() {
    if (widget.images.isNotEmpty) {
      _imageTimer = Timer.periodic(
        3.seconds,
        (Timer _) => _imagesController.animateToPage(
          _currentImagePage++ % widget.images.length,
          curve: Curves.linear,
          duration: 500.ms,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return widget.images.isEmpty
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
                      itemCount: widget.images.length,
                      itemBuilder: (BuildContext context, int index) => ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          widget.images[index],
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
                        count: widget.images.length,
                        effect: const WormEffect(dotHeight: 5, activeDotColor: purple),
                        onDotClicked: (int dot) => _imagesController.jumpToPage(dot),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
