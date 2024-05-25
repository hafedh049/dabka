import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';
import '../client/holder.dart';
import 'select_language.dart';
import 'welcome.dart';
import 'what_is_your_gender.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();

  final GlobalKey<State<StatefulWidget>> _pageKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _skipKey = GlobalKey<State<StatefulWidget>>();

  late final List<Widget> _pages = <Widget>[
    Welcome(pageController: _pageController),
    SelectLanguage(pageController: _pageController),
    const WhatIsYourGender(),
  ];

  int _currentIndex = 0;

  final List<Image> _images = <Image>[
    Image.asset("assets/images/welcome.png"),
    Image.asset("assets/images/language.png"),
    Image.asset("assets/images/gender.png"),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            StatefulBuilder(
              key: _skipKey,
              builder: (BuildContext context, void Function(void Function()) _) => _currentIndex > 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
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
                                backgroundColor: WidgetStatePropertyAll<Color>(white),
                                shadowColor: WidgetStatePropertyAll<Color>(dark),
                                elevation: WidgetStatePropertyAll<double>(2),
                                padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(2)),
                              ),
                              child: Text("Skip".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : const SizedBox(),
            ),
            Expanded(
              child: PageView.builder(
                onPageChanged: (int page) {
                  _currentIndex = page;
                  _skipKey.currentState!.setState(() {});
                  _pageKey.currentState!.setState(() {});
                },
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) => _images[index],
                itemCount: _images.length,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: StatefulBuilder(
                key: _pageKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: dark.withOpacity(.1), offset: const Offset(2, 4), blurStyle: BlurStyle.outer),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (int index = 0; index < 3; index += 1) ...<Widget>[
                              AnimatedContainer(
                                duration: 300.ms,
                                curve: Curves.easeInOut,
                                width: index == _currentIndex ? 20 : 10,
                                height: 5,
                                decoration: BoxDecoration(color: index == _currentIndex ? purple : grey, borderRadius: BorderRadius.circular(5)),
                              ),
                              if (index != 2) const SizedBox(width: 5),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        _pages[_currentIndex],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
