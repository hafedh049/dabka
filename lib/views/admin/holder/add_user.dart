import 'dart:io';

import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscureText = true;

  File? _image;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
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
                          controller: _usernameController,
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
                      Text("E-mail", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _usernameController,
                          style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(6),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                            hintText: "E-mail",
                            hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            labelText: "Enter your e-mail",
                            labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                            prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.lock_solid, color: grey, size: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      Text("Password", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
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
                                labelText: "كلمة المرور",
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      Text("Phone Number", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
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
                          title: "حدد الدولة",
                          searchBoxRadius: 5,
                          searchHintText: "بحث",
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
                          labelText: "رقم الهاتف",
                          floatingLabelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                          radius: 8,
                          hintText: "رقم الهاتف",
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
