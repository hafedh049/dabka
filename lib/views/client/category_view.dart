import 'package:another_xlider/another_xlider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/helpers/home_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../models/product_model.dart';
import '../../utils/helpers/home_ads_carousel.dart';
import '../../utils/helpers/home_sellers.dart';
import '../../utils/shared.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key, required this.category});
  final CategoryModel category;
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<UserModel> _sellers = <UserModel>[];
  List<Widget> _components = <Widget>[];
  Map<CategoryModel, List<ProductModel>> _products = <CategoryModel, List<ProductModel>>{};

  final GlobalKey<State<StatefulWidget>> _filterKey = GlobalKey<State<StatefulWidget>>();

  List<ProductModel> _filteredProducts(List<ProductModel> products) {
    switch (_sortBy) {
      case 0:
        return products..sort((ProductModel a, ProductModel b) => a.productName.compareTo(b.productName));
      case 1:
        return products.where((ProductModel element) => element.productBuyPrice >= _min && element.productBuyPrice <= _max).toList();
      case 2:
        return products..sort((ProductModel a, ProductModel b) => a.productRating.compareTo(b.productRating));
      default:
        return products;
    }
  }

  Future<bool> _load() async {
    try {
      _products = <CategoryModel, List<ProductModel>>{widget.category: <ProductModel>[]};

      final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("products").where('categoryID', isEqualTo: widget.category.categoryID).get();

      for (final CategoryModel categoryModel in _products.keys) {
        _products[categoryModel]!.clear();
        _products[categoryModel] = query.docs.where((QueryDocumentSnapshot<Map<String, dynamic>> element) => element.get('categoryID') == categoryModel.categoryID).toList().map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).toList();
      }

      final QuerySnapshot<Map<String, dynamic>> sellersQuery = await FirebaseFirestore.instance.collection("users").where('categoryID', isEqualTo: widget.category.categoryID).get();

      _sellers = sellersQuery.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => UserModel.fromJson(e.data())).toList();

      _components = <Widget>[
        const HomeAdsCarousel(),
        const SizedBox(height: 20),
        HomeSellers(sellers: _sellers),
        const SizedBox(height: 20),
        StatefulBuilder(
          key: _filterKey,
          builder: (BuildContext context, void Function(void Function()) _) {
            return HomePart(
              categoryModel: widget.category,
              products: _filteredProducts(
                _products[widget.category]!
                    .where(
                      (ProductModel element) => element.productName.toLowerCase().startsWith(
                            _searchController.text.trim().toLowerCase(),
                          ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ];
      return true;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

  int _sortBy = 0;

  double _min = 11, _max = 100;

  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = <String>["A-Z".tr, "Lower Price".tr, "Rating".tr];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: white,
          title: Text(widget.category.categoryName, style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 20, color: purple)),
          actions: <Widget>[
            TextButton.icon(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                backgroundColor: const WidgetStatePropertyAll<Color>(blue),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Sort By".tr, style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 20),
                        Center(
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  for (int index = 0; index < _filters.length; index++)
                                    InkWell(
                                      hoverColor: transparent,
                                      splashColor: transparent,
                                      highlightColor: transparent,
                                      onTap: () {
                                        _filterKey.currentState!.setState(() {});
                                        _(() => _sortBy = index);
                                      },
                                      child: AnimatedContainer(
                                        width: double.infinity,
                                        duration: 200.ms,
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: _sortBy == index ? purple : transparent),
                                        child: AnimatedDefaultTextStyle(
                                          duration: 200.ms,
                                          style: GoogleFonts.abel(fontSize: 12, color: _sortBy == index ? white : dark, fontWeight: FontWeight.w500),
                                          child: Text(_filters[index]),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: .3, thickness: .3, color: grey),
                        const SizedBox(height: 20),
                        Text("Price Range".tr, style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 20),
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return Row(
                              children: <Widget>[
                                Text(_min.toStringAsFixed(0), style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FlutterSlider(
                                    values: <double>[_min, _max],
                                    rangeSlider: true,
                                    max: 5000,
                                    min: 10,
                                    onDragging: (int handlerIndex, dynamic lowerValue, dynamic upperValue) {
                                      _min = lowerValue;
                                      _max = upperValue;
                                      _(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(_max.toStringAsFixed(0), style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          hoverColor: transparent,
                          splashColor: transparent,
                          highlightColor: transparent,
                          onTap: () {
                            _filterKey.currentState!.setState(() {});
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                            child: Text("Done".tr, style: GoogleFonts.abel(color: white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Bootstrap.filter, size: 15, color: dark),
                  const SizedBox(width: 5),
                  Text("Filters".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _load(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Card(
                    shadowColor: dark,
                    color: white,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
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
                                          onChanged: (String e) => _filterKey.currentState!.setState(() {}),
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Search for products".tr,
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
                          const SizedBox(height: 20),
                          ..._components,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
