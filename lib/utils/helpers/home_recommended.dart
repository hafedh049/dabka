import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../shared.dart';

class HomeRecommended extends StatefulWidget {
  const HomeRecommended({super.key, required this.recommended});
  final List<Map<String, dynamic>> recommended;

  @override
  State<HomeRecommended> createState() => _HomeRecommendedState();
}

class _HomeRecommendedState extends State<HomeRecommended> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Recommended for you", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        CarouselSlider.builder(
          itemCount: widget.recommended.length,
          itemBuilder: (BuildContext context, int index, int realIndex) => Image.asset("assets/images/${widget.recommended[index]}"),
          options: CarouselOptions(),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: 0,
          count: widget.recommended.length,
        ),
      ],
    );
  }
}
