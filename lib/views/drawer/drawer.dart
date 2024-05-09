import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/drawer/about_us/about_us.dart';
import 'package:dabka/views/drawer/become_seller.dart';
import 'package:dabka/views/drawer/installment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class DDrawer extends StatefulWidget {
  const DDrawer({super.key});

  @override
  State<DDrawer> createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  final List<Map<String, dynamic>> _tiles = <Map<String, dynamic>>[
    <String, dynamic>{
      "icon": FontAwesome.house_chimney_solid,
      "tile": "الرئيسية",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": Bootstrap.grid,
      "tile": "الفئات",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": FontAwesome.database_solid,
      "tile": "الأقساط",
      "page": const Installment(),
    },
    <String, dynamic>{"tile": "DIVIDER"},
    <String, dynamic>{
      "icon": FontAwesome.user_tag_solid,
      "tile": "الحساب التعريفي",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": FontAwesome.user_tag_solid,
      "tile": "الإعدادات",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": FontAwesome.heart,
      "tile": "المفضلات",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": FontAwesome.user_plus_solid,
      "tile": "المتابعون",
      "page": const SizedBox(),
    },
    <String, dynamic>{"tile": "DIVIDER"},
    <String, dynamic>{
      "icon": FontAwesome.shop_solid,
      "tile": "اصبح بائعًا",
      "page": const BecomeSeller(),
    },
    <String, dynamic>{
      "icon": Bootstrap.hexagon_half,
      "tile": "معلومات عنا",
      "page": const AboutUs(),
    },
  ];
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
