import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared.dart';
import '../holder/holder.dart';

class WhatIsYourGender extends StatefulWidget {
  const WhatIsYourGender({super.key});

  @override
  State<WhatIsYourGender> createState() => _WhatIsYourGenderState();
}

class _WhatIsYourGenderState extends State<WhatIsYourGender> {
  String _gender = "Male";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "What's your gender?",
          style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Gender Selection helps us to sort the categories according to your interests",
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
                  onTap: () => _gender == "Male" ? null : _(() => _gender = "Male"),
                  child: AnimatedContainer(
                    duration: 300.ms,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: white,
                      border: Border.all(color: _gender == "Male" ? pink : grey, width: _gender == "Male" ? .8 : .3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Male",
                      style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text("Or", style: GoogleFonts.abel(fontSize: 12, color: grey, fontWeight: FontWeight.w500)),
                const SizedBox(width: 10),
                InkWell(
                  splashColor: transparent,
                  hoverColor: transparent,
                  highlightColor: transparent,
                  onTap: () => _gender == "Female" ? null : _(() => _gender = "Female"),
                  child: AnimatedContainer(
                    duration: 300.ms,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: white,
                      border: Border.all(color: _gender == "Female" ? pink : grey, width: _gender == "Female" ? .8 : .3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Female",
                      style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Holder()),
            (Route _) => false,
          ),
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll<Color>(purple),
            padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 24)),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Text("Start", style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
