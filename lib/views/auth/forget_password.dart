// ignore_for_file: use_build_context_synchronously

import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/auth/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key, this.passed = false});
  final bool passed;
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _oobCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _oobCodeController.dispose();
    _newPasswordController.dispose();
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
          title: Text("Reset you password", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
          elevation: 5,
          shadowColor: dark,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(child: Image.asset("assets/icons/lock.png", width: 150, height: 150)),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "Please enter your phone number to get an sms",
                  style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
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
                  title: "Select the country",
                  searchBoxRadius: 5,
                  searchHintText: "Search",
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
                  labelText: "Phone Number",
                  floatingLabelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                  radius: 8,
                  hintText: "Phone Number",
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
              Center(child: Text("OR", style: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500))),
              const SizedBox(height: 10),
              const Divider(indent: 50, endIndent: 50, color: grey, height: .2, thickness: .2),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Please enter your phone number to get an sms",
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
                        labelText: "E-mail",
                        labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                        prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.envelope_solid, color: grey, size: 15)),
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
                  onTap: () async {
                    if (_emailController.text.contains(RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w-]{2,4}$'))) {
                      showToast(context, "We will send an e-mail to your registered e-mail address");
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                      showToast(context, "Confirmation E-mail sent");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PopScope(
                          canPop: false,
                          child: AlertDialog(
                            content: Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                    child: StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) _) {
                                        return TextField(
                                          controller: _oobCodeController,
                                          style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(6),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                            hintText: "...",
                                            hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                            labelText: "OOB Code",
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
                                          controller: _newPasswordController,
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
                                            labelText: "New Password",
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
                                  Row(
                                    children: <Widget>[
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          if (_oobCodeController.text.trim().isEmpty) {
                                            showToast(context, "You should enter the OOB Code", color: red);
                                          } else if (_newPasswordController.text.trim().isEmpty) {
                                            showToast(context, "Enter you new password to verify its you", color: red);
                                          } else {
                                            try {
                                              await FirebaseAuth.instance.confirmPasswordReset(
                                                code: _oobCodeController.text.trim().split("?").last.split("&").firstWhere((String element) => element.startsWith("oobCode")).split("=").last,
                                                newPassword: _newPasswordController.text,
                                              );
                                              showToast(context, "Congratulations, your password has been changed");
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn()), (Route route) => false);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                              showToast(context, e.toString(), color: red);
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                          backgroundColor: const WidgetStatePropertyAll<Color>(purple),
                                        ),
                                        child: Text("CONFIRM", style: GoogleFonts.abel(fontSize: 18, color: white, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ButtonStyle(
                                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                          backgroundColor: const WidgetStatePropertyAll<Color>(purple),
                                        ),
                                        child: Text("CANCEL", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      showToast(context, "Enter a correct e-mail address", color: red);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 48),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                    child: Text("SEND", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
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
