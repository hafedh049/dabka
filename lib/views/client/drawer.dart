import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/client/home.dart';
import 'package:dabka/views/client/about_us.dart';
import 'package:dabka/views/client/become_seller.dart';
import 'package:dabka/views/client/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import 'category_grid.dart';

class DDrawer extends StatefulWidget {
  const DDrawer({super.key});

  @override
  State<DDrawer> createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  late final List<Map<String, dynamic>> _tiles;
  @override
  void initState() {
    _tiles = <Map<String, dynamic>>[
      <String, dynamic>{
        "icon": FontAwesome.house_chimney_solid,
        "tile": "Home",
        "page": Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
            centerTitle: true,
            backgroundColor: white,
            title: Text("Home", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
            elevation: 5,
            shadowColor: dark,
          ),
          body: const Padding(padding: EdgeInsets.all(8), child: Home()),
        ),
      },
      <String, dynamic>{
        "icon": Bootstrap.grid,
        "tile": "Categories",
        "page": const CategoryGrid(),
      },
      <String, dynamic>{"tile": "DIVIDER"},
      <String, dynamic>{
        "icon": FontAwesome.gear_solid,
        "tile": "Settings",
        "page": const Settings(),
      },
      <String, dynamic>{"tile": "DIVIDER"},
      if (FirebaseAuth.instance.currentUser != null)
        <String, dynamic>{
          "icon": FontAwesome.shop_solid,
          "tile": "Become a seller",
          "page": const BecomeSeller(),
        },
      <String, dynamic>{
        "icon": Bootstrap.hexagon_half,
        "tile": "About Us",
        "page": const AboutUs(),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              for (final Map<String, dynamic> tile in _tiles) ...<Widget>[
                tile["tile"] == "DIVIDER"
                    ? const Divider(indent: 25, endIndent: 25, color: grey, height: .3, thickness: .3)
                    : InkWell(
                        splashColor: transparent,
                        highlightColor: transparent,
                        hoverColor: transparent,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => tile["page"])),
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