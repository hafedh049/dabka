import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared.dart';

class DirectInstallment extends StatelessWidget {
  const DirectInstallment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Direct Installment", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(
          "Through these systems, you can pay installments without any banking procedures. You must only meet the conditions of any of these systems",
          style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: AssetImage("assets/images/valu.png"), fit: BoxFit.cover)),
              ),
              const SizedBox(height: 10),
              Text("Valu Installment", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "You must download the valu application on the mobile and complete the registration steps. Valu will be contacted to finalize the procedures You can shop through the website or visit our branches The installment period starts from 3 months up to 6 months on a super hetrick system without interest You can also choose the installment period from 9 months to 60 months.",
          style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: const DecorationImage(image: AssetImage("assets/images/aman.png"), fit: BoxFit.cover)),
              ),
              const SizedBox(height: 10),
              Text("Aman Installment", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "You can now pay installments from 3 months to 36 months with an accumulating interest of 1.6% per month Installment is available at the official price, not the offer price. When choosing a 12-month installment period, a 5% down payment + 5% administrative expenses of the product value will be paid. When choosing a 24-month installment period, an amount of 10% administrative fees is paid from the value of the product. When choosing a 36- month installment period, an amount of 15% administrative fees will be paid from the value of the product. Installment service is available all over the republic. There is an inquiry fee of 50 pounds that will not be refunded if the application is rejected.In the event that the installment amount exceeds 10 thousand pounds, or the resident with a new rent requires the presence of a guarantor. The permissible age for installments is from 21 years to 65 years with the end of the installment period. You can also now submit a request for installment and receipt on the same day through the Enjazny system. For inquiries, call 16420. Get an Aman credit card with a purchase limit of up to 100,000 pounds and a repayment period of up to 36 months. To apply for the card, call 16420. Terms and conditions apply.",
          style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            hoverColor: transparent,
            splashColor: transparent,
            highlightColor: transparent,
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
              child: Text("Request", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}
