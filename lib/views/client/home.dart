import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/offer_model.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/helpers/categories_list.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/exclusive_offers.dart';
import '../../utils/helpers/home_ads_carousel.dart';
import '../../utils/helpers/home_part.dart';
import '../../utils/helpers/home_sellers.dart';
import '../../utils/helpers/wait.dart';
import '../../utils/shared.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<OfferModel> _exclusiveOffers = <OfferModel>[];
  Map<CategoryModel, List<ProductModel>> _products = <CategoryModel, List<ProductModel>>{};
  List<UserModel> _sellers = <UserModel>[];

  List<Widget> _components = <Widget>[];

  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<State<StatefulWidget>> _filterKey = GlobalKey<State<StatefulWidget>>();

  Future<bool> _load() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> categoryQuery = await FirebaseFirestore.instance.collection("categories").get();

      _products = <CategoryModel, List<ProductModel>>{for (final QueryDocumentSnapshot<Map<String, dynamic>> item in categoryQuery.docs) CategoryModel.fromJson(item.data()): <ProductModel>[]};

      final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("products").get();

      for (final CategoryModel categoryModel in _products.keys) {
        _products[categoryModel]!.clear();
        _products[categoryModel] = query.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get('categoryID') == categoryModel.categoryID).toList().map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).toList();
      }

      final QuerySnapshot<Map<String, dynamic>> offersQuery = await FirebaseFirestore.instance.collection("offers").get();

      _exclusiveOffers = offersQuery.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => OfferModel.fromJson(e.data())).toList();

      final QuerySnapshot<Map<String, dynamic>> sellersQuery = await FirebaseFirestore.instance.collection("users").where('userType', arrayContains: 'SUPPLIER').get();

      _sellers = sellersQuery.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => UserModel.fromJson(e.data())).toList();

      return true;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _load(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Card(
                  elevation: 6,
                  shadowColor: dark,
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              onChanged: (String itm) => _filterKey.currentState!.setState(() {}),
                              controller: _searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search".tr,
                                contentPadding: const EdgeInsets.all(16),
                                hintStyle: GoogleFonts.itim(color: grey, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                          child: const Icon(FontAwesome.searchengin_brand, color: white, size: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StatefulBuilder(
                  key: _filterKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    _components = <Widget>[
                      const SizedBox(height: 20),
                      const HomeAdsCarousel(),
                      const SizedBox(height: 20),
                      CategoriesList(categories: _products.keys.where((CategoryModel element) => element.categoryName.toLowerCase().startsWith(_searchController.text.trim().toLowerCase())).toList()),
                      ExclusiveOffers(exclusiveOffers: _exclusiveOffers.where((OfferModel element) => element.offerName.toLowerCase().startsWith(_searchController.text.trim().toLowerCase())).toList()),
                      for (final MapEntry<CategoryModel, List<ProductModel>> item in _products.entries) HomePart(categoryModel: item.key, products: item.value.where((ProductModel element) => element.productName.toLowerCase().startsWith(_searchController.text.trim().toLowerCase())).toList()),
                      HomeSellers(sellers: _sellers.where((UserModel element) => (FirebaseAuth.instance.currentUser == null ? true : element.userID != element.userID) && element.username.toLowerCase().startsWith(_searchController.text.trim().toLowerCase())).toList()),
                    ];
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) => _components[index],
                      itemCount: _components.length,
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Wait();
        } else {
          return ErrorScreen(error: snapshot.error.toString());
        }
      },
    );
  }
}
