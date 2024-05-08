import 'package:dabka/views/auth/sign_in.dart';
import 'package:dabka/views/drawer/drawer.dart';
import 'package:dabka/views/holder/home.dart';
import 'package:dabka/views/holder/true_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/shared.dart';

class Holder extends StatefulWidget {
  const Holder({super.key});

  @override
  State<Holder> createState() => _HolderState();
}

class _HolderState extends State<Holder> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State<StatefulWidget>> _menuKey = GlobalKey<State<StatefulWidget>>();

  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pages = <Map<String, dynamic>>[
    <String, dynamic>{
      "title": "الرئيسية",
      "icon": FontAwesome.house_solid,
      "page": const Home(),
    },
    <String, dynamic>{
      "title": "المقاطع",
      "icon": FontAwesome.image,
      "page": const TrueView(),
    },
    <String, dynamic>{
      "title": "المحادثات",
      "icon": FontAwesome.message,
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "title": "العروض",
      "icon": FontAwesome.heart,
      "page": const SizedBox(),
    },
    <String, dynamic>{
      "title": "الحجوزات",
      "icon": FontAwesome.wolf_pack_battalion_brand,
      "page": () => const SignIn(passed: true),
    },
  ];

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: const DDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text(appTitle, style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
        leading: IconButton(
          onPressed: () => _drawerKey.currentState!.openDrawer(),
          icon: const Icon(FontAwesome.bars_solid, size: 20, color: purple),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (int page) => _menuKey.currentState!.setState(() => _currentPage = page),
          itemBuilder: (BuildContext context, int index) => _pages[index]["page"],
          itemCount: _pages.length,
        ),
      ),
      bottomNavigationBar: StatefulBuilder(
        key: _menuKey,
        builder: (BuildContext context, void Function(void Function()) _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shadowColor: dark,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _pages
                      .map(
                        (Map<String, dynamic> e) => InkWell(
                          hoverColor: transparent,
                          splashColor: transparent,
                          highlightColor: transparent,
                          onTap: () => e["page"] is Callback
                              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => e["page"]()))
                              : _pageController.jumpToPage(
                                  _pages.indexOf(e),
                                ),
                          child: AnimatedContainer(
                            duration: 300.ms,
                            padding: EdgeInsets.symmetric(horizontal: _currentPage == _pages.indexOf(e) ? 10 : 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(e["icon"], size: 10, color: _currentPage == _pages.indexOf(e) ? purple : dark.withOpacity(.6)),
                                const SizedBox(height: 5),
                                AnimatedDefaultTextStyle(
                                  duration: 300.ms,
                                  style: GoogleFonts.abel(
                                    fontSize: 9,
                                    color: _currentPage == _pages.indexOf(e) ? purple : dark.withOpacity(.6),
                                    fontWeight: _currentPage == e["title"] ? FontWeight.bold : FontWeight.w500,
                                  ),
                                  child: Text(e["title"]),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
