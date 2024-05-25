import 'package:dabka/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../shared.dart';

class AvailablePaymentMethod extends StatefulWidget {
  const AvailablePaymentMethod({super.key, required this.product});
  final ProductModel product;
  @override
  State<AvailablePaymentMethod> createState() => _AvailablePaymentMethodState();
}

class _AvailablePaymentMethodState extends State<AvailablePaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Available payment methods".tr, style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            shadowColor: dark,
            elevation: 4,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(FontAwesome.cash_register_solid, size: 10, color: purple),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Cash", style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          Text("You can pay in cash to the vendor", style: GoogleFonts.abel(color: grey, fontSize: 8, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
