import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/shared.dart';
import '../holder/holder.dart';

class WhatIsYourGender extends StatefulWidget {
  const WhatIsYourGender({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<WhatIsYourGender> createState() => _WhatIsYourGenderState();
}

class _WhatIsYourGenderState extends State<WhatIsYourGender> {
  String _gender = "Male";
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
                      offset: 2,
                      count: 3,
                      size: Size.fromWidth(100),
                      effect: WormEffect(activeDotColor: purple, dotColor: grey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "What's your gender?",
                      style: GoogleFonts.itim(fontSize: 22, color: dark, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Gender Selection helps us to sort the categories according to your interests",
                      style: GoogleFonts.itim(fontSize: 12, color: grey, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              splashColor: transparent,
                              hoverColor: transparent,
                              highlightColor: transparent,
                              onTap: () => _gender == "Male" ? null : _(() => _gender = "Male"),
                              child: AnimatedContainer(
                                duration: 300.ms,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: white,
                                  border: Border.all(color: _gender == "Male" ? pink : grey, width: _gender == "Male" ? .8 : .3),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Male",
                                  style: GoogleFonts.itim(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text("Or", style: GoogleFonts.itim(fontSize: 12, color: grey, fontWeight: FontWeight.w500)),
                            const SizedBox(width: 10),
                            InkWell(
                              splashColor: transparent,
                              hoverColor: transparent,
                              highlightColor: transparent,
                              onTap: () => _gender == "Female" ? null : _(() => _gender = "Female"),
                              child: AnimatedContainer(
                                duration: 300.ms,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: white,
                                  border: Border.all(color: _gender == "Female" ? pink : grey, width: _gender == "Female" ? .8 : .3),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Female",
                                  style: GoogleFonts.itim(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
