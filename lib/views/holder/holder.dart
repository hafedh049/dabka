import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  final List<Map<String, dynamic>> _pages = const <Map<String, dynamic>>[
    <String, dynamic>{
      "title": "Home",
      "image": FontAwesome.house_solid,
      "page": SizedBox(),
    },
    <String, dynamic>{
      "title": "True View",
      "image": FontAwesome.image,
      "page": SizedBox(),
    },
    <String, dynamic>{
      "title": "Offers",
      "image": FontAwesome.heart,
      "page": SizedBox(),
    },
    <String, dynamic>{
      "title": "Booking",
      "image": FontAwesome.wolf_pack_battalion_brand,
      "page": SizedBox(),
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text(appTitle, style: GoogleFonts.abel(fontSize: 25, fontWeight: FontWeight.w500, color: blue)),
        leading: IconButton(
          onPressed: () => _drawerKey.currentState!.openDrawer(),
          icon: const Icon(FontAwesome.bars_solid, size: 25, color: blue),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) => _menuKey.currentState!.setState(() => _currentPage = _pages[page]["title"]),
        itemBuilder: (BuildContext context, int index) => _pages[index]["page"],
        itemCount: _pages.length,
      ),
      bottomNavigationBar: StatefulBuilder(
        key: _menuKey,
        builder: (BuildContext context, void Function(void Function()) _) {
          return Row(
            children: _pages
                .map(
                  (Map<String, dynamic> e) => InkWell(
                    hoverColor: transparent,
                    splashColor: transparent,
                    highlightColor: transparent,
                    onTap: () => _pageController.jumpToPage(_pages.indexOf(e)),
                    child: AnimatedContainer(
                      duration: 300.ms,
                      padding: EdgeInsets.symmetric(horizontal: _currentPage == e["title"] ? 10 : 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(e["icon"], size: 20, color: _currentPage == e["title"] ? purple : grey),
                          const SizedBox(height: 5),
                          AnimatedDefaultTextStyle(
                            duration: 300.ms,
                            style: GoogleFonts.abel(fontSize: 12, color: _currentPage == e["title"] ? purple : grey, fontWeight: _currentPage == e["title"] ? FontWeight.bold : FontWeight.w500),
                            child: Text(e["title"]),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
