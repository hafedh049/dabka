import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/language_model.dart';
import '../../utils/shared.dart';
import '../holder/holder.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final List<Language> _list = const <Language>[
    Language('English'),
    Language('العربية الدارجة'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const Holder()),
                    (Route _) => false,
                  ),
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(white),
                    shadowColor: MaterialStatePropertyAll<Color>(dark),
                  ),
                  child: Text("Skip", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Expanded(child: Image.asset("assets/images/language.png")),
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
                      offset: 1,
                      count: 3,
                      size: Size.fromWidth(100),
                      effect: WormEffect(activeDotColor: purple, dotColor: grey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Select you language",
                      style: GoogleFonts.itim(fontSize: 22, color: dark, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Please choose your preferred language",
                      style: GoogleFonts.itim(fontSize: 12, color: grey, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomDropdown<Language>.search(
                      hintText: 'Select you language',
                      items: _list,
                      excludeSelected: false,
                      initialItem: const Language("English"),
                      onChanged: (Language value) {},
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => widget.pageController.nextPage(duration: 300.ms, curve: Curves.linear),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(purple)),
                      child: Text("Next", style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w300)),
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
