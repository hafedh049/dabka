import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../utils/helpers/categories_list.dart';
import '../../../utils/helpers/error.dart';
import '../../../utils/helpers/home_ads_carousel.dart';
import '../../../utils/helpers/home_part.dart';
import '../../../utils/helpers/wait.dart';
import '../../utils/shared.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  Map<CategoryModel, List<ProductModel>> _products = <CategoryModel, List<ProductModel>>{};

  List<Widget> _components = <Widget>[];

  Future<bool> _load() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> categoryQuery = await FirebaseFirestore.instance.collection("categories").get();

      _products = <CategoryModel, List<ProductModel>>{for (final QueryDocumentSnapshot<Map<String, dynamic>> item in categoryQuery.docs) CategoryModel.fromJson(item.data()): <ProductModel>[]};

      final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("products").get();

      for (final CategoryModel categoryModel in _products.keys) {
        _products[categoryModel]!.clear();
        _products[categoryModel] = query.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get('categoryID') == categoryModel.categoryID).toList().map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).toList();
      }

      _components = <Widget>[
        const HomeAdsCarousel(),
        CategoriesList(categories: _products.keys.toList()),
        for (final MapEntry<CategoryModel, List<ProductModel>> item in _products.entries) HomePart(categoryModel: item.key, products: item.value),
      ];
      return true;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
        centerTitle: true,
        backgroundColor: white,
        title: Text("Categories", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
        elevation: 5,
        shadowColor: dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<bool>(
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
        ),
      ),
    );
  }
}
