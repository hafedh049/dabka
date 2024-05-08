import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/shared.dart';

class BecomeSeller extends StatefulWidget {
  const BecomeSeller({super.key});

  @override
  State<BecomeSeller> createState() => _BecomeSellerState();
}

class _BecomeSellerState extends State<BecomeSeller> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();

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
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(16),
                child: Image.asset("assets/images/logo.png", width: 80, height: 80),
              ),
              elevation: 4,
              shadowColor: dark,
            ),
            const SizedBox(height: 10),
            Text("Join Our Team", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: dark)),
            const SizedBox(height: 10),
            Text("Let our journey begin", style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.bold, color: dark.withOpacity(.4))),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) _) {
                  return TextField(
                    controller: _storeNameController,
                    style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(6),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                      hintText: "Store Name",
                      hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                      labelText: "Store Name",
                      labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                      prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.lock_solid, color: grey, size: 15)),
                      suffixIcon: IconButton(
                        onPressed: () => _(() => _storeNameController.text = ""),
                        icon: Icon(FontAwesome.circle_xmark_solid, color: grey, size: 15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
