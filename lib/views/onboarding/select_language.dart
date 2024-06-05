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
  final List<String> _locales = const <String>["en", "fr", "ar"];

  @override
  Widget build(BuildContext context) {
    final List<Language> list = <Language>[
      Language('English'.tr),
      Language('Français'.tr),
      Language('العربية'.tr),
    ];
    return Column(
      children: <Widget>[
        Text(
          "Please pick you favorite language".tr,
          style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 6,
          shadowColor: dark,
          child: CustomDropdown<Language>(
            hintText: "Choose your language".tr,
            items: list,
            excludeSelected: false,
            initialItem: list[_locales.indexOf(settingsBox!.get("language"))],
            onChanged: (Language? value) async {
              await settingsBox!.put("language", _locales[list.indexOf(value!)]);
              await Get.updateLocale(Locale(_locales[list.indexOf(value)]));
            },
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
