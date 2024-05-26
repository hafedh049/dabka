// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/order_model.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/available_payment_method.dart';
import 'package:dabka/utils/helpers/select_request_reservation.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:uuid/uuid.dart';

import '../utils/helpers/product_description.dart';
import '../utils/helpers/product_review.dart';
import '../utils/helpers/provided_by.dart';

class Product extends StatefulWidget {
  const Product({super.key, required this.product});
  final ProductModel product;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int _selectedPicture = 0;
  final GlobalKey<State<StatefulWidget>> _imagesKey = GlobalKey<State<StatefulWidget>>();
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
            collapsedHeight: 40,
            expandedHeight: 400,
            toolbarHeight: 35,
            stretch: true,
            automaticallyImplyLeading: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(111),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      highlightColor: transparent,
                      splashColor: transparent,
                      hoverColor: transparent,
                      onTap: () => Navigator.pop(context),
                      child: Card(
                        color: white,
                        shadowColor: pink,
                        borderOnForeground: true,
                        elevation: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(FontAwesome.chevron_left_solid, size: 20, color: pink),
                        ),
                      ),
                    ),
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
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  widget.product.productRating.toStringAsFixed(1),
                                  style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 3),
                                const Icon(FontAwesome.star, size: 8, color: purple),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                const Icon(FontAwesome.share_nodes_solid, size: 15, color: dark),
                                Text("Share".tr, style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.w500)),
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
                                Text("Video".tr, style: GoogleFonts.abel(color: widget.product.productShorts.isEmpty ? dark.withOpacity(.4) : dark, fontSize: 10, fontWeight: FontWeight.w500)),
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
                                const Icon(FontAwesome.heart, size: 15, color: dark),
                                Text("Favorite", style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            shadowColor: dark,
            shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
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
                          itemBuilder: (BuildContext context, int index) => Image.network(widget.product.productImages[index].path, fit: BoxFit.cover),
                          itemCount: widget.product.productImages.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      if (widget.product.productImages.length > 1)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 40,
                            height: 30,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: dark),
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
                const SizedBox(height: 130),
              ],
            ),
          ),
          SliverList.list(
            children: <Widget>[
              RequestReservation(product: widget.product),
              AvailablePaymentMethod(product: widget.product),
              ProductDescription(product: widget.product),
              ProductReview(product: widget.product),
              ProvidedBy(product: widget.product),
            ],
          ),
        ],
      ),
      bottomSheet: Container(
        height: 40,
        margin: const EdgeInsets.all(8),
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
                    const Icon(Bootstrap.chat_square_quote, size: 15, color: purple),
                    const SizedBox(width: 10),
                    Text("Seller Chat".tr, style: GoogleFonts.abel(color: purple, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Are you sure ?".tr, style: GoogleFonts.abel(color: purple, fontSize: 18, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 20),
                          Text("${'Total Cart'.tr} (${widget.product.productBuyPrice.toStringAsFixed(2)} DT)", style: GoogleFonts.abel(color: purple, fontSize: 18, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              const Spacer(),
                              TextButton(
                                onPressed: () async {
                                  final String orderID = const Uuid().v8();
                                  String username = '';

                                  final DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

                                  username = userDoc.get('userName');
                                  await FirebaseFirestore.instance.collection('orders').doc(orderID).set(
                                        OrderModel(
                                          orderID: orderID,
                                          ownerID: FirebaseAuth.instance.currentUser!.uid,
                                          timestamp: Timestamp.now().toDate(),
                                          ownerName: username,
                                          products: <ProductModel>[widget.product],
                                        ).toJson(),
                                      );
                                  showToast(context, 'Product Requested Successfully'.tr);
                                  Navigator.pop(context);
                                },
                                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                child: Text("Confirm".tr, style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(blue)),
                                child: Text("Cancel".tr, style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  decoration: const BoxDecoration(color: purple, borderRadius: BorderRadius.only(topRight: Radius.circular(22), bottomRight: Radius.circular(22))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(FontAwesome.cart_shopping_solid, size: 15, color: white),
                      const SizedBox(width: 10),
                      Text("Request Reservation".tr, style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.bold)),
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
