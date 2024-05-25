import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
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
  final List<Language> _list = <Language>[
    Language('English'.tr),
    Language('Français'.tr),
    Language('العربية'.tr),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Choose you language".tr, style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Text(
          "Please pick you favorite language".tr,
          style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 6,
          shadowColor: dark,
          child: CustomDropdown<Language>.search(
            hintText: "Choose your language".tr,
            items: _list,
            excludeSelected: false,
            initialItem: _list.first,
            onChanged: (Language value) {},
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => widget.pageController.nextPage(duration: 300.ms, curve: Curves.linear),
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll<Color>(purple),
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24)),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Text("Next".tr, style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
