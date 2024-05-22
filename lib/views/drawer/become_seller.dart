import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dabka/utils/helpers/category_filter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';

import '../../utils/shared.dart';

class BecomeSeller extends StatefulWidget {
  const BecomeSeller({super.key});

  @override
  State<BecomeSeller> createState() => _BecomeSellerState();
}

class _BecomeSellerState extends State<BecomeSeller> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String _category = "";

  final List<Category> _list = const <Category>[
    Category('Photographers'),
    Category('Dresses'),
    Category("Makeup Artists"),
    Category("Halls"),
    Category("Trips"),
    Category("Beauty Centers"),
  ];

  Future<void> _joinUs() async {
    _category = _category;
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Container()));
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text("Become a Seller", style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple)),
        elevation: 6,
        shadowColor: dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            Text("Join Our Team", style: GoogleFonts.abel(fontSize: 15, fontWeight: FontWeight.bold, color: dark)),
            const SizedBox(height: 5),
            Text("Let our journey begin", style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.bold, color: dark.withOpacity(.6))),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return TextField(
                    controller: _storeNameController,
                    style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                    onChanged: (String value) => _(() {}),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(6),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      hintText: "Store Name",
                      hintStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                      labelText: "Store Name",
                      labelStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                      prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.shop_solid, color: grey, size: 15)),
                      suffixIcon: _storeNameController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () => _(() => _storeNameController.text = ""),
                              icon: const Icon(FontAwesome.circle_xmark_solid, color: grey, size: 15),
                            ),
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
                    controller: _usernameController,
                    onChanged: (String value) => _(() {}),
                    style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(6),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      hintText: "Your Name",
                      hintStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                      labelText: "Your Name",
                      labelStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                      prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.user_solid, color: grey, size: 15)),
                      suffixIcon: _usernameController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () => _(() => _usernameController.text = ""),
                              icon: const Icon(FontAwesome.circle_xmark_solid, color: grey, size: 15),
                            ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            InternationalPhoneNumberInput(
              height: 40,
              controller: _phoneNumberController,
              formatter: MaskedInputFormatter('## ### ###'),
              initCountry: CountryCodeModel(name: "Tunisia", dial_code: "+216", code: "TN"),
              betweenPadding: 10,
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
                textStyle: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              phoneConfig: PhoneConfig(
                focusedColor: grey,
                enabledColor: grey,
                errorColor: grey,
                labelStyle: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.w500),
                labelText: "رقم الهاتف",
                floatingLabelStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
                radius: 8,
                hintText: "رقم الهاتف",
                borderWidth: .3,
                backgroundColor: transparent,
                decoration: null,
                popUpErrorText: false,
                showCursor: true,
                autovalidateMode: AutovalidateMode.disabled,
                textStyle: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.w300),
                hintStyle: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            Card(
              elevation: 2,
              shadowColor: dark,
              child: SizedBox(
                height: 40,
                child: CustomDropdown<Category>.search(
                  headerBuilder: (BuildContext context, Category selectedItem) => Text(
                    selectedItem.name,
                    style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  hintText: "Pick Category",
                  closedHeaderPadding: const EdgeInsets.all(10),
                  items: _list,
                  excludeSelected: false,
                  initialItem: const Category('Photographers'),
                  onChanged: (Category value) => _category = value.name,
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
                child: Text("Join Us", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
