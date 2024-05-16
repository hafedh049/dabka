import 'package:dabka/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Description", style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            shadowColor: dark,
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.sizeOf(context).width,
              child: Text(widget.product.productDescription, style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 8, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
