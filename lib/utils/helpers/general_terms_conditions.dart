import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralTermsConditions extends StatelessWidget {
  const GeneralTermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("General terms & conditions", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(
          "The customer must be have a debit card (credit card). It should be valid, and there must be enough balance in the card to be sold for the full price of the product.",
          style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
