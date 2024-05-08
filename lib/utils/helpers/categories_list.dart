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
        Text("الاقسام", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
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
                    for (final Map<String, dynamic> category in widget.categories)
                      Card(
                        child: Container(
                          height: 100,
                          width: 60,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(category["icon"]), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: category["color"] == "pink"
                                        ? pink
                                        : category["color"] == "blue"
                                            ? blue
                                            : purple,
                                    width: .2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                              ),
                              const SizedBox(height: 10),
                              Text(category["name"], style: GoogleFonts.abel(color: dark, fontSize: 8, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}
