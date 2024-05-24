import 'package:another_xlider/another_xlider.dart';
import 'package:dabka/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/shared.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key, required this.category});
  final CategoryModel category;
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int _sortBy = 0;
  double _min = 0, _max = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = <String>["A-Z", "Lower Price", "Rating", "Newer"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text(widget.category.categoryName, style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.bars_solid, size: 20, color: purple)),
        actions: <Widget>[
          TextButton.icon(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              backgroundColor: const WidgetStatePropertyAll<Color>(grey),
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
                      Text("Sort By", style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
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
                                    onTap: () => _(() => _sortBy = index),
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
                      Text("Price Range", style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return Row(
                            children: <Widget>[
                              Text(_min.toStringAsFixed(0), style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 10),
                              FlutterSlider(
                                values: const <double>[30, 420],
                                rangeSlider: true,
                                max: 5000,
                                min: 10,
                                onDragging: (int handlerIndex, dynamic lowerValue, dynamic upperValue) {
                                  _min = lowerValue;
                                  _max = upperValue;
                                  _(() {});
                                },
                              ),
                              const SizedBox(width: 10),
                              Text(_max.toStringAsFixed(0), style: GoogleFonts.abel(fontSize: 12, color: purple, fontWeight: FontWeight.w500)),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        hoverColor: transparent,
                        splashColor: transparent,
                        highlightColor: transparent,
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                          child: Text("Done", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
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
                Text("Filters", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
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
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search for products",
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
