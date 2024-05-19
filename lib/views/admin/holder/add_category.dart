import 'dart:io';

import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _categoryNameController = TextEditingController();

  File? _image;

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(FontAwesome.chevron_left_solid, size: 15, color: purple),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () async {},
                child: AnimatedContainer(
                  width: 80,
                  height: 80,
                  duration: 300.ms,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: white,
                    border: Border.all(color: grey.withOpacity(.3), width: 2),
                    image: _image == null ? DecorationImage(image: AssetImage("assets/images/nobody.png"), fit: BoxFit.cover) : DecorationImage(image: FileImage(_image!), fit: BoxFit.cover),
                  ),
                ),
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
                      Text("Username", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _categoryNameController,
                          style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(6),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            hintText: "Username",
                            hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            labelText: "Enter username",
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
                child: InkWell(
                  hoverColor: transparent,
                  splashColor: transparent,
                  highlightColor: transparent,
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                    child: Text("Create User", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
