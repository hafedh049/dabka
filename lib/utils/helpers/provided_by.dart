// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/views/supplier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../shared.dart';

class ProvidedBy extends StatefulWidget {
  const ProvidedBy({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProvidedBy> createState() => _ProvidedByState();
}

class _ProvidedByState extends State<ProvidedBy> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Provided By".tr, style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('users').doc(widget.product.supplierID).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                final UserModel user = UserModel.fromJson(snapshot.data!.data()!);
                return GestureDetector(
                  onTap: () async => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Supplier(supplier: user))),
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      shadowColor: gold,
                      elevation: 4,
                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage(widget.product.productImages.first.path), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(widget.product.categoryName, style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 10, fontWeight: FontWeight.w500)),
                                      const Spacer(),
                                      Card(
                                        color: white,
                                        shadowColor: dark,
                                        elevation: 2,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(widget.product.productRating.toStringAsFixed(1), style: GoogleFonts.abel(color: dark, fontSize: 9, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 3),
                                              const Icon(FontAwesome.star, size: 9, color: purple),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(user.username, style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  InkWell(
                                    splashColor: transparent,
                                    highlightColor: transparent,
                                    hoverColor: transparent,
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: blue),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Icon(FontAwesome.circle_user, size: 15, color: white),
                                          const SizedBox(width: 5),
                                          Text("Follow".tr, style: GoogleFonts.abel(color: white, fontSize: 10, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
