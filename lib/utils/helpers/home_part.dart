import 'package:cached_network_image/cached_network_image.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/models/product_model.dart';
import 'package:flutter/material.dart';
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
        Text(categoryModel.categoryName, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset("assets/images/thumbnail1.png", fit: BoxFit.cover, height: 100, width: double.infinity)),
        const SizedBox(height: 10),
        products.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) => Stack(
                  children: <Widget>[
                    Container(
                      height: 350,
                      width: 200,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: CachedNetworkImageProvider(products[index].productImages.first.path), fit: BoxFit.cover)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white),
                            child: Text("${products[index].productRating.toStringAsFixed(1)} ★", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 150,
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
                    Column(
                      children: <Widget>[
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(color: pink, borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(FontAwesome.database_solid, color: white, size: 15),
                        ),
                        const SizedBox(height: 10),
                        Text("Installment Available", style: GoogleFonts.abel(color: pink, fontSize: 8, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Text(products[index].productName, style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(products[index].supplierID, style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          child: Text("${products[index].productBuyPrice.toStringAsFixed(3).replaceAll(".", ",")} TND", style: GoogleFonts.abel(color: pink, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
                itemCount: products.length,
              ),
      ],
    );
  }
}
