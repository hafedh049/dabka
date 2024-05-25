// ignore_for_file: use_build_context_synchronously

import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/auth/sign_up.dart';
import 'package:dabka/views/auth/forget_password.dart';
import 'package:dabka/views/client/holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

import '../../utils/callbacks.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, this.passed = false});
  final bool passed;
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _ignoreStupidity = false;

  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
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
          leading: widget.passed ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)) : null,
          centerTitle: true,
          backgroundColor: white,
          title: Text("Sign-In".tr, style: GoogleFonts.abel(fontSize: 22, color: dark, fontWeight: FontWeight.bold)),
          elevation: 5,
          shadowColor: dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(child: Image.asset("assets/images/logo.png", width: 150, height: 150)),
              const SizedBox(height: 40),
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
                  title: "Select the country".tr,
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
              InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ForgetPassword())),
                child: Text("Did you forget you password ?".tr, style: GoogleFonts.abel(color: purple, fontSize: 12, fontWeight: FontWeight.bold)),
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
                          if (!_emailController.text.contains(RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,4}$'))) {
                            showToast(context, "Enter a correct e-mail address".tr, color: red);
                          } else if (_passwordController.text.isEmpty) {
                            showToast(context, "Enter a correct password".tr, color: red);
                          } else {
                            try {
                              _(() => _ignoreStupidity = true);
                              showToast(context, "Please wait...".tr);
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()), (Route route) => false);
                              showToast(context, "Welcome back".tr);
                              _(() => _ignoreStupidity = false);
                            } catch (e) {
                              showToast(context, e.toString(), color: red);
                              _(() => _ignoreStupidity = false);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                          child: Text("Sign-in".tr, style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: InkWell(
                  hoverColor: transparent,
                  splashColor: transparent,
                  highlightColor: transparent,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignUp())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 48),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: purple)),
                    child: Text("Create account".tr, style: GoogleFonts.abel(color: purple, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: Text("OR".tr, style: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500))),
              const SizedBox(height: 10),
              const Divider(indent: 50, endIndent: 50, color: grey, height: .2, thickness: .2),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      hoverColor: transparent,
                      splashColor: transparent,
                      highlightColor: transparent,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.1)),
                        child: const Icon(FontAwesome.google_brand, size: 25, color: red),
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      hoverColor: transparent,
                      splashColor: transparent,
                      highlightColor: transparent,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.1)),
                        child: const Icon(FontAwesome.facebook_f_brand, size: 25, color: blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
