import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/helpers/home_part.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../models/product_model.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key, required this.supplier});
  final UserModel supplier;
  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  final List<Map<String, dynamic>> _methods = <Map<String, dynamic>>[
    <String, dynamic>{"icon": "assets/images/wallet.png", "method": "Wallet".tr},
    <String, dynamic>{"icon": "assets/images/card.png", "method": "Credit".tr},
    <String, dynamic>{"icon": "assets/images/ticket.png", "method": "Money".tr},
  ];

  CategoryModel? _category;

  List<ProductModel> _products = <ProductModel>[];

  Future<bool> _load() async {
    final QuerySnapshot<Map<String, dynamic>> productsQuery = await FirebaseFirestore.instance.collection("products").where("supplierID", isEqualTo: widget.supplier.userID).get();

    _products = productsQuery.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).toList();

    final QuerySnapshot<Map<String, dynamic>> categoryQuery = await FirebaseFirestore.instance.collection("categories").where("categoryID", isEqualTo: widget.supplier.categoryID).limit(1).get();

    _category = CategoryModel.fromJson(categoryQuery.docs.first.data());

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text("Supplier Profile".tr, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    image: widget.supplier.userAvatar.isEmpty
                        ? DecorationImage(
                            image: AssetImage("assets/images/${widget.supplier.gender == 'M' ? 'n' : 'f'}obody.png"),
                            fit: BoxFit.contain,
                          )
                        : DecorationImage(
                            image: NetworkImage(widget.supplier.userAvatar),
                            fit: BoxFit.cover,
                          ),
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: blue),
                  ),
                ),
                const SizedBox(height: 20),
                Text(widget.supplier.username, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.supplier.categoryName.toUpperCase(), style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      color: white,
                      borderOnForeground: true,
                      elevation: 4,
                      shadowColor: blue,
                      child: Container(padding: const EdgeInsets.all(8), child: const Icon(FontAwesome.user_plus_solid, color: blue, size: 15)),
                    ),
                    const SizedBox(width: 20),
                    Card(
                      color: blue,
                      borderOnForeground: true,
                      elevation: 4,
                      shadowColor: blue,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          children: <Widget>[
                            const Icon(Bootstrap.chat_square_text, color: white, size: 20),
                            const SizedBox(width: 10),
                            Text("Chat".tr, style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(FontAwesome.user_plus_solid, color: blue, size: 20),
                    const SizedBox(height: 10),
                    Text(widget.supplier.followers.toString(), style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text("Followers".tr, style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 60,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(color: white, border: Border.all(width: 3, color: grey.withOpacity(.3)), shape: BoxShape.circle),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(_methods[index]["icon"], fit: BoxFit.cover, width: 25, height: 25, color: blue),
                    const SizedBox(height: 2),
                    Text(_methods[index]["method"], style: GoogleFonts.abel(color: dark, fontSize: 9, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
              itemCount: _methods.length,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
            child: FutureBuilder<bool>(
              future: _load(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AnimatedContainer(
                        duration: 300.ms,
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: blue, width: 2))),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: AnimatedDefaultTextStyle(
                          style: GoogleFonts.abel(color: blue, fontSize: 12, fontWeight: FontWeight.bold),
                          duration: 300.ms,
                          child: Text("All Products".tr),
                        ),
                      ),
                      const SizedBox(height: 10),
                      HomePart(categoryModel: _category!, products: _products),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
