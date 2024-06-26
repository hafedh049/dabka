import 'package:dabka/views/auth/sign_in.dart';
import 'package:dabka/views/client/booking.dart';
import 'package:dabka/views/client/offers.dart';
import 'package:dabka/views/client/drawer.dart';
import 'package:dabka/views/client/chats.dart';
import 'package:dabka/views/client/home.dart';
import 'package:dabka/views/client/true_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
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

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = <Map<String, dynamic>>[
      <String, dynamic>{
        "title": "Home".tr,
        "icon": FontAwesome.house_solid,
        "page": const Home(),
      },
      <String, dynamic>{
        "title": "True Views".tr,
        "icon": FontAwesome.image,
        "page": const TrueView(),
      },
      <String, dynamic>{
        "title": "Chats".tr,
        "icon": FontAwesome.message,
        "page": const Chats(),
      },
      <String, dynamic>{
        "title": "Offers".tr,
        "icon": FontAwesome.heart,
        "page": const OffersList(),
      },
      <String, dynamic>{
        "title": "Bookings".tr,
        "icon": FontAwesome.wolf_pack_battalion_brand,
        "page": FirebaseAuth.instance.currentUser == null ? () => const SignIn(passed: true) : const BookingList(),
      },
    ];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _drawerKey,
        drawer: const DDrawer(),
        appBar: AppBar(
          centerTitle: true,
          elevation: 8,
          shadowColor: dark,
          backgroundColor: white,
          title: Text("DabKa".tr, style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
          leading: IconButton(onPressed: () => _drawerKey.currentState!.openDrawer(), icon: const Icon(FontAwesome.bars_solid, size: 20, color: purple)),
        ),
        backgroundColor: white,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) => _menuKey.currentState!.setState(() => _currentPage = page),
            itemBuilder: (BuildContext context, int index) => pages[index]["page"],
            itemCount: pages.length,
          ),
        ),
        bottomNavigationBar: StatefulBuilder(
          key: _menuKey,
          builder: (BuildContext context, void Function(void Function()) _) {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: Card(
                elevation: 6,
                shadowColor: dark,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: pages
                        .map(
                          (Map<String, dynamic> e) => InkWell(
                            hoverColor: transparent,
                            splashColor: transparent,
                            highlightColor: transparent,
                            onTap: () => e["page"] is Callback ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => e["page"]())) : _pageController.jumpToPage(pages.indexOf(e)),
                            child: AnimatedContainer(
                              duration: 300.ms,
                              padding: EdgeInsets.symmetric(horizontal: _currentPage == pages.indexOf(e) ? 10 : 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(e["icon"], size: 15, color: _currentPage == pages.indexOf(e) ? purple : dark.withOpacity(.6)),
                                  const SizedBox(height: 5),
                                  AnimatedDefaultTextStyle(
                                    duration: 300.ms,
                                    style: GoogleFonts.abel(
                                      fontSize: 12,
                                      color: _currentPage == pages.indexOf(e) ? purple : dark.withOpacity(.6),
                                      fontWeight: _currentPage == e["title"] ? FontWeight.bold : FontWeight.w500,
                                    ),
                                    child: Text(e["title"]),
                                  ),
                                  if (_currentPage == pages.indexOf(e)) ...<Widget>[
                                    const SizedBox(height: 5),
                                    Container(color: purple, height: 2, width: 10),
                                  ],
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
      ),
    );
  }
}
