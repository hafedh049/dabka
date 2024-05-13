import 'package:dabka/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../shared.dart';

class ProductReview extends StatefulWidget {
  const ProductReview({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Text("Reviews", style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: Card(
              shadowColor: dark,
              elevation: 4,
              child: Column(
                children: <Widget>[
                  Card(
                    shadowColor: dark,
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Text("Over all rate", style: GoogleFonts.abel(color: grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Card(
                            color: white,
                            shadowColor: dark,
                            elevation: 2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    widget.product.productRating.toStringAsFixed(1),
                                    style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(FontAwesome.star, size: 9, color: purple),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            splashColor: transparent,
                            hoverColor: transparent,
                            highlightColor: transparent,
                            onTap: () {},
                            child: Text("Write review", style: GoogleFonts.abel(color: grey, fontSize: 10, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(child: LottieBuilder.asset("assets/lotties/empty.json")),
                        Text("No reviews yet", style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
