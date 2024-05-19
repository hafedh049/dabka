import 'package:dabka/views/admin/holder/category_list.dart';
import 'package:dabka/views/admin/holder/chat_list.dart';
import 'package:dabka/views/admin/holder/orders_list.dart';
import 'package:dabka/views/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../models/category_model.dart';
import '../../../models/chat_head_model.dart';
import '../../../models/order_model.dart';
import '../../../models/user_account_model.dart';
import '../../../utils/shared.dart';
import 'users_list.dart';

class Holder extends StatefulWidget {
  const Holder({super.key});

  @override
  State<Holder> createState() => _HolderState();
}

class _HolderState extends State<Holder> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State<StatefulWidget>> _menuKey = GlobalKey<State<StatefulWidget>>();

  final PageController _pageController = PageController();

  List<Map<String, dynamic>> _pages = <Map<String, dynamic>>[];

  int _currentPage = 0;

  List<UserModel> _users = <UserModel>[];
  List<ChatHead> _chats = <ChatHead>[];
  List<CategoryModel> _categories = <CategoryModel>[];
  List<OrderModel> _orders = <OrderModel>[];

  Future<bool> _load() async {
    try {
      _pages = <Map<String, dynamic>>[
        <String, dynamic>{
          "title": "Users",
          "icon": FontAwesome.users_between_lines_solid,
          "page": UsersList(users: _users),
        },
        <String, dynamic>{
          "title": "Categories",
          "icon": FontAwesome.square_solid,
          "page": CategoriesList(categories: _categories),
        },
        <String, dynamic>{
          "title": "Orders",
          "icon": FontAwesome.first_order_brand,
          "page": OrdersList(orders: _orders),
        },
        <String, dynamic>{
          "title": "Chats",
          "icon": FontAwesome.heart,
          "page": ChatsList(chats: _chats),
        },
      ];
      return true;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

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
        leading: IconButton(onPressed: () => _drawerKey.currentState!.openDrawer(), icon: const Icon(FontAwesome.bars_solid, size: 20, color: purple)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<bool>(
          future: _load(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int page) => _menuKey.currentState!.setState(() => _currentPage = page),
              itemBuilder: (BuildContext context, int index) => _pages[index]["page"],
              itemCount: _pages.length,
            );
          },
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
                          onTap: () => _pageController.jumpToPage(_pages.indexOf(e)),
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
                                if (_currentPage == _pages.indexOf(e)) ...<Widget>[
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
    );
  }
}
