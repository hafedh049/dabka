import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/helpers/language_filter.dart';
import '../../utils/shared.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final List<Language> _list = const <Language>[
    Language('English'),
    Language('Français'),
    Language('العربية الدارجة'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("اختر لغتك", style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Text(
          "الرجاء اختيار لغتك المفضلة",
          style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 6,
          shadowColor: dark,
          child: CustomDropdown<Language>.search(
            hintText: 'اختر لغتك',
            items: _list,
            excludeSelected: false,
            initialItem: const Language('العربية الدارجة'),
            onChanged: (Language value) {},
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => widget.pageController.nextPage(duration: 300.ms, curve: Curves.linear),
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll<Color>(purple),
            padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24)),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Text("التالي", style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
