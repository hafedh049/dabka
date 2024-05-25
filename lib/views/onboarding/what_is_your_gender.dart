import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';
import '../client/holder.dart';

class WhatIsYourGender extends StatefulWidget {
  const WhatIsYourGender({super.key});

  @override
  State<WhatIsYourGender> createState() => _WhatIsYourGenderState();
}

class _WhatIsYourGenderState extends State<WhatIsYourGender> {
  String _gender = "M";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "What is you gender?".tr,
          style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Selecting you gender helps us to filter out the categories for you".tr,
          style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
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
                  onTap: () => _gender == "M" ? null : _(() => _gender = "M"),
                  child: AnimatedContainer(
                    duration: 300.ms,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: white,
                      border: Border.all(color: _gender == "M" ? pink : grey, width: _gender == "M" ? .8 : .3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Male".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 10),
                Text("OR", style: GoogleFonts.abel(fontSize: 12, color: grey, fontWeight: FontWeight.w500)),
                const SizedBox(width: 10),
                InkWell(
                  splashColor: transparent,
                  hoverColor: transparent,
                  highlightColor: transparent,
                  onTap: () => _gender == "F" ? null : _(() => _gender = "F"),
                  child: AnimatedContainer(
                    duration: 300.ms,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: white,
                      border: Border.all(color: _gender == "F" ? pink : grey, width: _gender == "F" ? .8 : .3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Female".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            settingsBox!.put("first_time", false);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()), (Route _) => false);
          },
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll<Color>(purple),
            padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24)),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Text("Get Started".tr, style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
