import 'package:cached_network_image/cached_network_image.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/views/client/category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../shared.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key, required this.categories});
  final List<CategoryModel> categories;
  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Categories".tr, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        widget.categories.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  runSpacing: 20,
                  spacing: 10,
                  children: <Widget>[
                    for (final CategoryModel category in widget.categories)
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CategoryView(category: category))),
                        child: Card(
                          child: Container(
                            height: 120,
                            width: 80,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: CachedNetworkImageProvider(category.categoryUrl), fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: blue, width: .2),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                ),
                                const SizedBox(height: 10),
                                Text(category.categoryName, style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: (widget.categories.indexOf(category) * 120).ms),
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}
