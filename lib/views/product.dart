import 'package:dabka/models/product_model.dart';
import 'package:dabka/utils/helpers/available_payment_method.dart';
import 'package:dabka/utils/helpers/select_request_reservation.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils/helpers/product_description.dart';
import '../utils/helpers/product_details.dart';
import '../utils/helpers/product_review.dart';

class Product extends StatefulWidget {
  const Product({super.key, required this.product});
  final ProductModel product;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int _selectedPicture = 0;
  final GlobalKey<State<StatefulWidget>> _imagesKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _appBarKey = GlobalKey<State<StatefulWidget>>();
  bool _hidePart = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 4,
            forceElevated: true,
            excludeHeaderSemantics: true,
            backgroundColor: white,
            centerTitle: true,
            collapsedHeight: 90,
            expandedHeight: 400,
            toolbarHeight: 35,
            onStretchTrigger: () async => print(1), // _appBarKey.currentState!.setState(() => _hidePart = !_hidePart),
            title: Text(widget.product.productName, style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
            leading: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white),
              padding: const EdgeInsets.all(2),
              child: Icon(FontAwesome.chevron_left_solid, color: dark, size: 15),
            ),
            shadowColor: dark,
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
            flexibleSpace: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: PageView.builder(
                          onPageChanged: (int image) => _imagesKey.currentState!.setState(() => _selectedPicture = image),
                          itemBuilder: (BuildContext context, int index) => Image.network(widget.product.productImages[index], fit: BoxFit.cover),
                          itemCount: widget.product.productImages.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 40,
                          height: 30,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple.withOpacity(.4)),
                          child: StatefulBuilder(
                            key: _imagesKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Text(
                                "${_selectedPicture + 1} / ${widget.product.productImages.length}",
                                style: GoogleFonts.abel(color: white, fontSize: 10, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StatefulBuilder(
                  key: _appBarKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return _hidePart
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Installment Available", style: GoogleFonts.abel(color: pink, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(widget.product.productName, style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w900)),
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
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Card(
                                      color: white,
                                      shadowColor: dark,
                                      elevation: 4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(FontAwesome.share_nodes_solid, size: 15, color: dark),
                                            Text("Share", style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: white,
                                      shadowColor: dark,
                                      elevation: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(FontAwesome.circle_play_solid, size: 15, color: widget.product.productShorts.isEmpty ? dark.withOpacity(.4) : dark),
                                            Text("Video", style: GoogleFonts.abel(color: widget.product.productShorts.isEmpty ? dark.withOpacity(.4) : dark, fontSize: 10, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: white,
                                      shadowColor: dark,
                                      elevation: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(FontAwesome.heart, size: 15, color: dark),
                                            Text("Favorite", style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
          SliverList.list(
            children: <Widget>[
              RequestReservation(product: widget.product),
              AvailablePaymentMethod(product: widget.product),
              ProductDetails(product: widget.product),
              ProductDescription(product: widget.product),
              ProductReview(product: widget.product),
              // ProvidedBy(product: widget.product),
            ],
          ),
        ],
      ),
      bottomSheet: Container(
        height: 40,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(width: 2, color: purple)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Bootstrap.chat_square_quote, size: 15, color: purple),
                    const SizedBox(width: 10),
                    Text("Seller Chat", style: GoogleFonts.abel(color: purple, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () {},
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.only(topRight: Radius.circular(22), bottomRight: Radius.circular(22))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(FontAwesome.cart_shopping_solid, size: 15, color: white),
                      const SizedBox(width: 10),
                      Text("Request Reservation", style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
