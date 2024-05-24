import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/offer_model.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/helpers/categories_list.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/exclusive_offers.dart';
import '../../utils/helpers/home_ads_carousel.dart';
import '../../utils/helpers/home_part.dart';
import '../../utils/helpers/home_filter.dart';
import '../../utils/helpers/home_sellers.dart';
import '../../utils/helpers/wait.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _images = <String>[];
  List<OfferModel> _exclusiveOffers = <OfferModel>[];
  Map<CategoryModel, List<ProductModel>> _products = <CategoryModel, List<ProductModel>>{};
  List<UserModel> _sellers = <UserModel>[];

  List<Widget> _components = <Widget>[];

  Future<bool> _load() async {
    try {
      _images = jsonDecode(await rootBundle.loadString("assets/jsons/ads.json")).cast<String>();

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

      _components = <Widget>[
        const HomeFilter(),
        HomeAdsCarousel(images: _images),
        CategoriesList(categories: _products.keys.toList()),
        ExclusiveOffers(exclusiveOffers: _exclusiveOffers),
        for (final MapEntry<CategoryModel, List<ProductModel>> item in _products.entries) HomePart(categoryModel: item.key, products: item.value),
        HomeSellers(sellers: _sellers),
      ];
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
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) => _components[index],
            itemCount: _components.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
            padding: EdgeInsets.zero,
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
