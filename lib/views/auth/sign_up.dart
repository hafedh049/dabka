import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, this.passed = false});
  final bool passed;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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
          title: Text("أفتح حساب الأن", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
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
              Center(
                child: Text(
                  "الرجاء إدخال رقم هاتفك لتلقي رمز التحقق",
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
                    child: Text("إرسال", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
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
