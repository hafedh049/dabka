// ignore_for_file: use_build_context_synchronously

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/views/supplier/holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';
import '../../utils/shared.dart';

class BecomeSeller extends StatefulWidget {
  const BecomeSeller({super.key});

  @override
  State<BecomeSeller> createState() => _BecomeSellerState();
}

class _BecomeSellerState extends State<BecomeSeller> {
  CategoryModel? _category;

  List<CategoryModel> _categories = <CategoryModel>[];

  Future<List<CategoryModel>> _loadCategories() async {
    final QuerySnapshot<Map<String, dynamic>> categoriesDoc = await FirebaseFirestore.instance.collection('categories').get();
    return categoriesDoc.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => CategoryModel.fromJson(doc.data()!)).toList();
  }

  Future<void> _joinUs() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
      <String, dynamic>{
        'userType': const <String>['CLIENT', 'SUPPLIER'],
        'categoryName': _category!.categoryName,
        'categoryID': _category!.categoryID,
      },
    );
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()), (Route route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.get('userType').contains('SUPPLIER')
              ? const Holder()
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: white,
                      title: Text("Become a Seller".tr, style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
                      leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
                      elevation: 6,
                      shadowColor: dark,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder<List<CategoryModel>>(
                        future: _loadCategories(),
                        builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            _categories = snapshot.data!;
                            _category = _categories.first;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Card(
                                  elevation: 4,
                                  shadowColor: dark,
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset("assets/images/logo.png", width: 80, height: 80),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text("Join Our Team".tr, style: GoogleFonts.abel(fontSize: 15, fontWeight: FontWeight.bold, color: dark)),
                                const SizedBox(height: 5),
                                Text("Let our journey begin".tr, style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.bold, color: dark.withOpacity(.6))),
                                const SizedBox(height: 20),
                                Card(
                                  elevation: 2,
                                  shadowColor: dark,
                                  child: SizedBox(
                                    height: 40,
                                    child: _categories.length == 1
                                        ? Text(_category!.categoryName, style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark.withOpacity(.6)))
                                        : CustomDropdown<CategoryModel>.search(
                                            headerBuilder: (BuildContext context, CategoryModel selectedItem) => Text(
                                              selectedItem.categoryName,
                                              style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.w500),
                                            ),
                                            hintText: "Pick Category".tr,
                                            closedHeaderPadding: const EdgeInsets.all(10),
                                            items: _categories,
                                            excludeSelected: false,
                                            initialItem: _categories[_categories.indexOf(_category!)],
                                            onChanged: (CategoryModel value) => _category = value,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                InkWell(
                                  hoverColor: transparent,
                                  splashColor: transparent,
                                  highlightColor: transparent,
                                  onTap: _joinUs,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                                    child: Text("Join Us".tr, style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                                  Text("Sorry you can't be a seller or a supplier if there is not categories please contact the admin".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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
                  ),
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
