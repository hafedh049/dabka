// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/admin/add_category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../../models/category_model.dart';
import '../../utils/callbacks.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});
  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> _categories = <CategoryModel>[];

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Categories List", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddCategory())),
              icon: const Icon(FontAwesome.circle_plus_solid, color: purple, size: 15),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
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
                            hintText: "Search",
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
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("_categories").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                _categories = snapshot.data!.docs.map((e) => CategoryModel.fromJson(e.data())).toList();
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onLongPress: () {
                      showBottomSheet(
                        context: context,
                        builder: (BuildContext context) => Container(
                          color: white,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Are you sure ?", style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance.collection("_categories").doc(snapshot.data!.docs[index].id).delete();
                                      showToast(context, "Category deleted successfully");
                                      Navigator.pop(context);
                                    },
                                    style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                    child: Text("OK", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.w500)),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(grey.withOpacity(.3))),
                                    child: Text("CANCEL", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shadowColor: dark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: white,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: _categories[index].categoryUrl.isEmpty
                                    ? const DecorationImage(
                                        image: AssetImage("assets/images/nobody.png"),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: NetworkImage(_categories[index].categoryUrl),
                                        fit: BoxFit.cover,
                                      ),
                                border: Border.all(width: 2, color: pink),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                  child: Text("CATEGORY ID", style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Flexible(child: Text(_categories[index].categoryID, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                  child: Text("CATEGORY NAME", style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Flexible(child: Text(_categories[index].categoryName, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                  itemCount: _categories.length,
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                      Text("No Categories Yet!", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Wait();
              } else {
                return ErrorScreen(error: snapshot.error.toString());
              }
            },
          ),
        ),
      ],
    );
  }
}