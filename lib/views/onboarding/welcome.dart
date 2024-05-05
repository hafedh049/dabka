import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Your wedding is much easier!",
          style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "We will help you with everything",
          style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => pageController.nextPage(duration: 300.ms, curve: Curves.linear),
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll<Color>(purple),
            padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24)),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Text(
            "Get Started",
            style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}