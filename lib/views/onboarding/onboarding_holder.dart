import 'package:flutter/material.dart';

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
  late final List<Widget> _pages = <Widget>[
    Welcome(pageController: _pageController),
    SelectLanguage(pageController: _pageController),
    WhatIsYourGender(pageController: _pageController),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) => _pages[index],
        itemCount: _pages.length,
      ),
    );
  }
}
