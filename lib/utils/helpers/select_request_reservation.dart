import 'package:dabka/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared.dart';

class RequestReservation extends StatefulWidget {
  const RequestReservation({super.key, required this.product});
  final ProductModel product;
  @override
  State<RequestReservation> createState() => _RequestReservationState();
}

class _RequestReservationState extends State<RequestReservation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Text("Select how you want to request reservation", style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (widget.product.productBuyPrice != 0)
                    InkWell(
                      highlightColor: transparent,
                      hoverColor: transparent,
                      splashColor: transparent,
                      onTap: () => _(() => _selectedIndex = 0),
                      child: AnimatedContainer(
                        duration: 300.ms,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: _selectedIndex == 0 ? purple : grey, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(widget.product.productBuyPrice.toStringAsFixed(1), style: GoogleFonts.aDLaMDisplay(color: dark, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 5),
                                Text("TND", style: GoogleFonts.abel(color: grey, fontSize: 8, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Card(
                              color: _selectedIndex == 0 ? purple : grey,
                              elevation: 4,
                              shadowColor: purple,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                child: Text("Buy", style: GoogleFonts.abel(color: white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.product.productSellPrice != 0)
                    InkWell(
                      highlightColor: transparent,
                      hoverColor: transparent,
                      splashColor: transparent,
                      onTap: () => _(() => _selectedIndex = 1),
                      child: AnimatedContainer(
                        duration: 300.ms,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: _selectedIndex == 1 ? purple : grey, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(widget.product.productSellPrice.toStringAsFixed(1), style: GoogleFonts.aDLaMDisplay(color: dark, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 5),
                                Text("TND", style: GoogleFonts.abel(color: grey, fontSize: 8, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Card(
                              color: _selectedIndex == 1 ? purple : grey,
                              elevation: 4,
                              shadowColor: purple,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                child: Text("Rent", style: GoogleFonts.abel(color: white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
