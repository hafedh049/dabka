import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../shared.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key, required this.categories});
  final List<Map<String, dynamic>> categories;
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
        Text("Our Categories", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        widget.categories.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                runSpacing: 20,
                spacing: 10,
                children: <Widget>[
                  for (final Map<String, dynamic> category in widget.categories)
                    Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: grey, width: .2),
                        boxShadow: <BoxShadow>[BoxShadow(color: grey.withOpacity(.2), blurStyle: BlurStyle.outer, offset: const Offset(0, 1))],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: category["color"] == "pink"
                                  ? pink
                                  : category["color"] == "blue"
                                      ? blue
                                      : purple,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(category["icon"]),
                          ),
                          const SizedBox(height: 20),
                          Text(category["name"], style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              ),
      ],
    );
  }
}
