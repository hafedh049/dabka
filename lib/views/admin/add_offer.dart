// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/category_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/callbacks.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({super.key});

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final TextEditingController _offerNameController = TextEditingController();

  final GlobalKey<State<StatefulWidget>> _offerImageKey = GlobalKey<State<StatefulWidget>>();

  File? _banner;

  bool _ignoreStupidity = false;

  @override
  void dispose() {
    _offerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StatefulBuilder(
                key: _offerImageKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return GestureDetector(
                    onTap: () async {
                      final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        _(() => _banner = File(file.path));
                      }
                    },
                    child: AnimatedContainer(
                      width: MediaQuery.sizeOf(context).width * .6,
                      height: 150,
                      duration: 300.ms,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: grey.withOpacity(.3), width: 2),
                        image: _banner == null
                            ? const DecorationImage(
                                image: AssetImage("assets/images/thumbnail1.png"),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: FileImage(_banner!),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Card(
                shadowColor: dark,
                color: white,
                elevation: 6,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Offer name", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _offerNameController,
                          style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(6),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            hintText: "Offer",
                            hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            labelText: "Enter the offer name",
                            labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.user, color: grey, size: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return IgnorePointer(
                      ignoring: _ignoreStupidity,
                      child: InkWell(
                        hoverColor: transparent,
                        splashColor: transparent,
                        highlightColor: transparent,
                        onTap: () async {
                          if (_offerNameController.text.trim().isEmpty) {
                            showToast(context, "Category name is required", color: red);
                          } else if (_banner == null) {
                            showToast(context, "Pick an image for the category", color: red);
                          } else {
                            try {
                              _(() => _ignoreStupidity = true);
                              showToast(context, "Please wait...");

                              final DocumentReference<Map<String, dynamic>> docRef = await FirebaseFirestore.instance.collection("categories").add(
                                    CategoryModel(
                                      categoryID: '',
                                      categoryName: _offerNameController.text,
                                      categoryUrl: '',
                                    ).toJson(),
                                  );

                              String path = "";

                              if (_banner != null) {
                                final TaskSnapshot task = await FirebaseStorage.instance.ref().child("/categories/${docRef.id}.png").putFile(_banner!);
                                path = await task.ref.getDownloadURL();
                              }

                              await docRef.update(
                                <String, dynamic>{
                                  'categoryID': docRef.id.trim(),
                                  'categoryUrl': path,
                                },
                              );

                              _offerNameController.clear();
                              _offerImageKey.currentState!.setState(() => _banner = null);

                              showToast(context, "Category Created Successfully");
                              _(() => _ignoreStupidity = false);
                            } catch (e) {
                              showToast(context, e.toString(), color: red);
                              _(() => _ignoreStupidity = false);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                          child: Text("Add Category", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
