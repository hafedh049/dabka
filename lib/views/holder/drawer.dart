import 'package:dabka/utils/shared.dart';
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
      "tile": "Home",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": Bootstrap.grid,
      "tile": "Categories",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": FontAwesome.database_solid,
      "tile": "Installments",
      "page": const SizedBox(),
    },
    <String, dynamic>{"tile": "DIVIDER"},
    <String, dynamic>{
      "icon": FontAwesome.user_tag_solid,
      "tile": "Profile",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": FontAwesome.heart,
      "tile": "Favorites",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": FontAwesome.user_plus_solid,
      "tile": "Followers",
      "page": const SizedBox(),
    },
    <String, dynamic>{"tile": "DIVIDER"},
    <String, dynamic>{
      "icon": FontAwesome.shop_solid,
      "tile": "Become a Seller",
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "icon": Bootstrap.hexagon_half,
      "tile": "About us",
      "page": const SizedBox(),
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
                  padding: const EdgeInsets.all(8),
                  child: Image.asset("assets/icons/lock.png", width: 60, height: 60),
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: tile["page"]))),
                        ),
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
