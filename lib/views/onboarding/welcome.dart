import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/shared.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Expanded(child: Image.asset("assets/images/welcome.png")),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const <BoxShadow>[BoxShadow(color: dark, offset: Offset(2, -5), blurStyle: BlurStyle.outer)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SmoothIndicator(
                      offset: 0,
                      count: 3,
                      size: Size.fromWidth(100),
                      effect: WormEffect(activeDotColor: purple, dotColor: grey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Your wedding is much easier!",
                      style: GoogleFonts.itim(fontSize: 22, color: dark, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "We will help you with everything",
                      style: GoogleFonts.itim(fontSize: 12, color: grey, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => pageController.nextPage(duration: 300.ms, curve: Curves.linear),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(purple)),
                      child: Text(
                        "Get Started",
                        style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
