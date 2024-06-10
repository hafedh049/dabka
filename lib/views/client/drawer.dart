import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/client/holder.dart';
import 'package:dabka/views/client/home.dart';
import 'package:dabka/views/drawer/about_us.dart';
import 'package:dabka/views/client/become_seller.dart';
import 'package:dabka/views/drawer/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'category_grid.dart';

class DDrawer extends StatefulWidget {
  const DDrawer({super.key});

  @override
  State<DDrawer> createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tiles = <Map<String, dynamic>>[
      <String, dynamic>{
        "icon": FontAwesome.house_chimney_solid,
        "tile": "Home".tr,
        "page": Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
            centerTitle: true,
            backgroundColor: white,
            title: Text("Home".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
            elevation: 5,
            shadowColor: dark,
          ),
          body: const Padding(padding: EdgeInsets.all(8), child: Home()),
        ),
      },
      <String, dynamic>{
        "icon": Bootstrap.grid,
        "tile": "Categories".tr,
        "page": const CategoryGrid(),
      },
      <String, dynamic>{"tile": "DIVIDER"},
      <String, dynamic>{
        "icon": FontAwesome.gear_solid,
        "tile": "Settings".tr,
        "page": const Settings(),
      },
      <String, dynamic>{"tile": "DIVIDER"},
      if (FirebaseAuth.instance.currentUser != null)
        <String, dynamic>{
          "icon": FontAwesome.shop_solid,
          "tile": "Become a seller".tr,
          "page": const BecomeSeller(),
        },
      <String, dynamic>{
        "icon": Bootstrap.hexagon_half,
        "tile": "About Us".tr,
        "page": const AboutUs(),
      },
      <String, dynamic>{
        "icon": Bootstrap.r_square,
        "tile": "Hot Restart".tr,
        "page": () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const Holder()), (Route route) => false),
      },
    ];
    return Drawer(
      width: 273,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: const CircleBorder(),
                elevation: 6,
                shadowColor: dark,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset("assets/images/logo.png", width: 60, height: 60),
                ),
              ),
              const SizedBox(height: 20),
              for (final Map<String, dynamic> tile in tiles) ...<Widget>[
                tile["tile"] == "DIVIDER"
                    ? const Divider(indent: 25, endIndent: 25, color: grey, height: .3, thickness: .3)
                    : InkWell(
                        splashColor: transparent,
                        highlightColor: transparent,
                        hoverColor: transparent,
                        onTap: tile["page"] is VoidCallback ? tile["page"] : () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => tile["page"])),
                        child: Row(
                          children: <Widget>[
                            Icon(tile["icon"], size: 20, color: dark.withOpacity(.5)),
                            const SizedBox(width: 20),
                            Text(tile["tile"], style: GoogleFonts.abel(color: dark.withOpacity(.9), fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
