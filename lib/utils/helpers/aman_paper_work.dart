import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmanPaperWork extends StatelessWidget {
  const AmanPaperWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Aman paperwork", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text("Public and private sector employees", style: GoogleFonts.abel(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text("Salary items accompanying receipt a copy of the identity card of the guarantor", style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 20),
        Text("Self-employed and commercial", style: GoogleFonts.abel(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text("Copy of tax card commercial register receipt of companion ID card guranator", style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 20),
        Text("Annuities", style: GoogleFonts.abel(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text("A stamped pension statement an accompanying receipt a copy of the identity card a copy of the identity card of the guarantor - A copy of the customer card and a copy of the guarantor card, both cards must be valid. - Utilities receipt (electricity, gas, water, telephone) that must be in the name of the customer (not to exceed three months from the date of submitting the application). - The address recorded in the receipt must be the same address in which the visit took place and the consumption value is indicated. In the absence of proof of income, a new car license that is no more than 5 years old can be submitted - In the absence of proof of income, a club card can be submitted, and the membership will be for the same year", style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
