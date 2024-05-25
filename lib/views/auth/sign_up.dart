// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart' as fis;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _phoneController = TextEditingController();

  File? _avatar;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  String _gender = "M";

  bool _ignoreStupidity = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
          centerTitle: true,
          backgroundColor: white,
          title: Text("Open an account now".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
          elevation: 5,
          shadowColor: dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) _) {
                    return InkWell(
                      hoverColor: transparent,
                      splashColor: transparent,
                      highlightColor: transparent,
                      onTap: () async {
                        final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          _(() => _avatar = File(image.path));
                          showToast(context, "Picture updates successfully".tr);
                        }
                      },
                      onLongPress: () {
                        if (_avatar != null) {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Are you sure you want to remove you picture ?".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                                  Row(
                                    children: <Widget>[
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          _(() => _avatar = null);
                                          showToast(context, "Picture removed".tr);
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                          backgroundColor: const WidgetStatePropertyAll<Color>(purple),
                                        ),
                                        child: Text("CONFIRM".tr, style: GoogleFonts.abel(fontSize: 16, color: white, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ButtonStyle(
                                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                          backgroundColor: const WidgetStatePropertyAll<Color>(purple),
                                        ),
                                        child: Text("CANCEL".tr, style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        elevation: 4,
                        borderOnForeground: true,
                        color: white,
                        shadowColor: dark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: fis.FlutterImageStack.providers(
                            providers: <ImageProvider>[
                              const AssetImage("assets/images/fobody.png"),
                              if (_avatar != null) FileImage(_avatar!) else const AssetImage("assets/images/nobody.png"),
                            ],
                            totalCount: 2,
                            itemBorderColor: purple,
                            itemCount: 2,
                            showTotalCount: true,
                            itemRadius: 100,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Please enter your phone number".tr,
                    style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        controller: _usernameController,
                        style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(6),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          hintText: "johny_english",
                          hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          labelText: "Username".tr,
                          labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.envelope_solid, color: grey, size: 15)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                InternationalPhoneNumberInput(
                  height: 40,
                  controller: _phoneController,
                  formatter: MaskedInputFormatter('## ### ###'),
                  initCountry: CountryCodeModel(name: "Tunisia".tr, dial_code: "+216", code: "TN"),
                  betweenPadding: 10,
                  onInputChanged: (IntPhoneNumber phone) {},
                  dialogConfig: DialogConfig(
                    backgroundColor: white,
                    searchBoxBackgroundColor: grey.withOpacity(.1),
                    searchBoxIconColor: grey,
                    countryItemHeight: 50,
                    topBarColor: grey,
                    selectedItemColor: grey,
                    selectedIcon: const Padding(padding: EdgeInsets.only(left: 10), child: Icon(FontAwesome.check_solid, size: 15, color: blue)),
                    textStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                    searchBoxTextStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                    titleStyle: GoogleFonts.abel(color: dark, fontSize: 16, fontWeight: FontWeight.bold),
                    searchBoxHintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                    flatFlag: true,
                    itemFlagSize: 20,
                    title: "Pick a country".tr,
                    searchBoxRadius: 5,
                    searchHintText: "Search".tr,
                  ),
                  countryConfig: CountryConfig(
                    decoration: BoxDecoration(border: Border.all(width: .3, color: grey), borderRadius: BorderRadius.circular(8)),
                    flatFlag: true,
                    flagSize: 20,
                    textStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  phoneConfig: PhoneConfig(
                    focusedColor: grey,
                    enabledColor: grey,
                    errorColor: grey,
                    labelStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                    labelText: "Phone Number".tr,
                    floatingLabelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                    radius: 8,
                    hintText: "Phone Number".tr,
                    borderWidth: .3,
                    backgroundColor: transparent,
                    decoration: null,
                    popUpErrorText: false,
                    showCursor: true,
                    autovalidateMode: AutovalidateMode.disabled,
                    textStyle: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                    hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        controller: _emailController,
                        style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(6),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          hintText: "abc@xyz.com",
                          hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          labelText: "E-mail".tr,
                          labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.envelope_solid, color: grey, size: 15)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(6),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                          hintText: "**********",
                          hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          labelText: "Password".tr,
                          labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.lock_solid, color: grey, size: 15)),
                          suffixIcon: IconButton(
                            onPressed: () => _(() => _obscureText = !_obscureText),
                            icon: Icon(_obscureText ? FontAwesome.eye_slash : FontAwesome.eye, color: grey, size: 15),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("What is you gender".tr, style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                splashColor: transparent,
                                hoverColor: transparent,
                                highlightColor: transparent,
                                onTap: () => _gender == "M" ? null : _(() => _gender = "M"),
                                child: AnimatedContainer(
                                  duration: 300.ms,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: white,
                                    border: Border.all(color: _gender == "M" ? pink : grey, width: _gender == "M" ? 2 : 1),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Text("Male".tr, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text("OR", style: GoogleFonts.abel(fontSize: 12, color: grey, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 10),
                              InkWell(
                                splashColor: transparent,
                                hoverColor: transparent,
                                highlightColor: transparent,
                                onTap: () => _gender == "F" ? null : _(() => _gender = "F"),
                                child: AnimatedContainer(
                                  duration: 300.ms,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: white,
                                    border: Border.all(color: _gender == "F" ? pink : grey, width: _gender == "F" ? 2 : 1),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Text("Female".tr, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) _) {
                    return IgnorePointer(
                      ignoring: _ignoreStupidity,
                      child: InkWell(
                        hoverColor: transparent,
                        splashColor: transparent,
                        highlightColor: transparent,
                        onTap: () async {
                          if (_usernameController.text.trim().isEmpty) {
                            showToast(context, "Username is required".tr, color: red);
                          } else if (_phoneController.text.trim().isEmpty) {
                            showToast(context, "Enter you phone number".tr, color: red);
                          } else if (!_emailController.text.contains(RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,4}$'))) {
                            showToast(context, "Verify the e-mail".tr, color: red);
                          } else if (_passwordController.text.trim().isEmpty || _passwordController.text.trim().length <= 4) {
                            showToast(context, "Password should be longer than 4 characters".tr, color: red);
                          } else {
                            try {
                              String imageUrl = "";

                              _(() => _ignoreStupidity = true);

                              showToast(context, "Please wait...".tr);

                              final UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());

                              if (_avatar != null) {
                                showToast(context, "Uploading Avatar Image...".tr);
                                await FirebaseStorage.instance.ref().child("/images/${credential.user!.uid}").putFile(_avatar!).then(
                                  (TaskSnapshot task) async {
                                    imageUrl = await task.ref.getDownloadURL();
                                  },
                                );
                                showToast(context, "Images Uploaded".tr);
                              }

                              await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set(
                                    UserModel(
                                      userID: credential.user!.uid,
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      phoneNumber: _phoneController.text.trim(),
                                      username: _usernameController.text.trim(),
                                      categoryName: '',
                                      categoryID: '',
                                      userAvatar: imageUrl,
                                      userType: const <String>["CLIENT"],
                                      userDescription: '',
                                      followers: 0,
                                      gender: _gender,
                                    ).toJson(),
                                  );

                              showToast(context, "User Created Successfully".tr);

                              Navigator.pop(context);

                              _(() => _ignoreStupidity = false);
                            } catch (e) {
                              debugPrint(e.toString());
                              showToast(context, e.toString(), color: red);
                              _(() => _ignoreStupidity = false);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 48),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                          child: Text("CREATE ACCOUNT".tr, style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
