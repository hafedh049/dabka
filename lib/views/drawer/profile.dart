// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
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

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _avatar;

  UserModel? userModel;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<State<StatefulWidget>> _avatarKey = GlobalKey<State<StatefulWidget>>();

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

  Future<bool> _updateProfile() async {
    final DocumentSnapshot<Map<String, dynamic>> userCredential = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    userModel = UserModel.fromJson(userCredential.data()!);
    _usernameController.text = userModel!.username;
    _emailController.text = userModel!.email;
    _passwordController.text = userModel!.password;
    _phoneController.text = userModel!.phoneNumber;
    _gender = userModel!.gender;
    return true;
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
          title: Text("Update your profile".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
          elevation: 5,
          shadowColor: dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<bool>(
            future: _updateProfile(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Center(
                        child: StatefulBuilder(
                          key: _avatarKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
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
                                      if (userModel!.userAvatar.isNotEmpty && _avatar == null)
                                        CachedNetworkImageProvider(
                                          userModel!.userAvatar,
                                        )
                                      else if (_avatar != null)
                                        FileImage(
                                          _avatar!,
                                        )
                                      else
                                        AssetImage(
                                          "assets/images/${_gender == 'M' ? 'n' : 'f'}obody.png",
                                        ),
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
                          },
                        ),
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
                        initCountry: CountryCodeModel(name: "Tunisia", dial_code: "+216", code: "TN"),
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
                              readOnly: true,
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
                              readOnly: true,
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
                            Text("What is you gender".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
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
                                      onTap: () {
                                        if (_gender != "M") {
                                          _(() => _gender = "M");
                                          if (_avatar == null) {
                                            _avatarKey.currentState!.setState(() {});
                                          }
                                        }
                                      },
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
                                      onTap: () {
                                        if (_gender != "F") {
                                          _(() => _gender = "F");
                                          if (_avatar == null) {
                                            _avatarKey.currentState!.setState(() {});
                                          }
                                        }
                                      },
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
                                } else {
                                  try {
                                    String imageUrl = userModel!.userAvatar;

                                    _(() => _ignoreStupidity = true);

                                    showToast(context, "Please wait...".tr);

                                    if (_avatar != null) {
                                      showToast(context, "Uploading Avatar Image...".tr);
                                      await FirebaseStorage.instance.ref().child("/images/${userModel!.userID}").putFile(_avatar!).then(
                                        (TaskSnapshot task) async {
                                          imageUrl = await task.ref.getDownloadURL();
                                        },
                                      );
                                      showToast(context, "Images Uploaded".tr);
                                    }

                                    await FirebaseFirestore.instance.collection("users").doc(userModel!.userID).update(
                                      <String, dynamic>{
                                        'userName': _usernameController.text.trim(),
                                        'userAvatar': imageUrl,
                                        'gender': _gender,
                                      },
                                    );

                                    showToast(context, "User Updated Successfully".tr);

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
                                child: Text("UPDATE".tr, style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Wait();
              }
              return ErrorScreen(error: snapshot.error.toString());
            },
          ),
        ),
      ),
    );
  }
}
