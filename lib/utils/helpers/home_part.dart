import 'package:cached_network_image/cached_network_image.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/views/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../shared.dart';

class HomePart extends StatelessWidget {
  const HomePart({super.key, required this.categoryModel, required this.products});
  final List<ProductModel> products;
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(categoryModel.categoryName.tr, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset("assets/images/thumbnail1.png", fit: BoxFit.cover, height: 100, width: double.infinity)),
        const SizedBox(height: 10),
        products.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 300,
                  width: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Product(product: products[index]))),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            height: 300,
                            width: 200,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: CachedNetworkImageProvider(products[index].productImages.first.path), fit: BoxFit.cover)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Spacer(),
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(color: white, border: Border.all(color: gold, width: 2)),
                                  child: Row(
                                    children: <Widget>[
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(color: gold, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))),
                                        child: const Icon(FontAwesome.crown_solid, color: white, size: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Spacer(),
                                Text(products[index].productName, style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  child: Text("${products[index].productBuyPrice.toStringAsFixed(3).replaceAll(".", ",")} " "TND".tr, style: GoogleFonts.abel(color: pink, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
                    itemCount: products.length,
                  ),
                ),
              ),
      ],
    );
  }
}
