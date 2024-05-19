import 'package:dabka/models/user_account_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key, required this.supplier});
  final UserModel supplier;
  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  final List<Map<String, dynamic>> _methods = <Map<String, dynamic>>[
    <String, dynamic>{"icon": "assets/images/wallet.png", "method": "Wallet"},
    <String, dynamic>{"icon": "assets/images/card.png", "method": "Credit"},
    <String, dynamic>{"icon": "assets/images/ticket.png", "method": "Cash"},
  ];

  List<String> _tabs = <String>["Dress"];
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(FontAwesome.chevron_left_solid, size: 25, color: dark)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(widget.supplier.userAvatar), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 2, color: blue),
                  ),
                ),
                const SizedBox(height: 20),
                Text(widget.supplier.username, style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.supplier.categoryName.toUpperCase(), style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 10, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      color: white,
                      borderOnForeground: true,
                      elevation: 4,
                      shadowColor: blue,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(FontAwesome.user_plus_solid, color: blue, size: 15),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Card(
                      color: blue,
                      borderOnForeground: true,
                      elevation: 4,
                      shadowColor: blue,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          children: <Widget>[
                            Icon(Bootstrap.chat_square_text, color: white, size: 20),
                            const SizedBox(width: 10),
                            Text("Chat", style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(FontAwesome.user_plus_solid, color: blue, size: 20),
                    const SizedBox(height: 10),
                    Text(widget.supplier.followers.toString(), style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text("Followers", style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 10, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 60,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(color: grey.withOpacity(.3), border: Border.all(width: 3, color: white), shape: BoxShape.circle),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(_methods[index]["icon"], fit: BoxFit.cover, width: 25, height: 25, color: blue),
                    const SizedBox(height: 2),
                    Text(_methods[index]["method"], style: GoogleFonts.abel(color: dark, fontSize: 9, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
              itemCount: _methods.length,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            hoverColor: transparent,
                            splashColor: transparent,
                            highlightColor: transparent,
                            onTap: () => _(() => _selectedTab = 0),
                            child: AnimatedContainer(
                              duration: 300.ms,
                              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _selectedTab == 0 ? blue : transparent, width: 2))),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: AnimatedDefaultTextStyle(
                                style: GoogleFonts.abel(color: _selectedTab == 0 ? blue : dark, fontSize: 12, fontWeight: FontWeight.bold),
                                duration: 300.ms,
                                child: Text("All Products"),
                              ),
                            ),
                          ),
                          for (final dynamic key in _tabs)
                            InkWell(
                              hoverColor: transparent,
                              splashColor: transparent,
                              highlightColor: transparent,
                              onTap: () => _(() => _selectedTab = _tabs.indexOf(key) + 1),
                              child: AnimatedContainer(
                                duration: 300.ms,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _selectedTab == _tabs.indexOf(key) + 1 ? blue : transparent, width: 2))),
                                padding: const EdgeInsets.all(16),
                                child: AnimatedDefaultTextStyle(
                                  duration: 300.ms,
                                  style: GoogleFonts.abel(color: _selectedTab == _tabs.indexOf(key) + 1 ? blue : dark, fontSize: 12, fontWeight: FontWeight.bold),
                                  child: Text(key),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                /*Wrap(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 350,
                          width: 200,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: AssetImage(dresses[index]["image"]), fit: BoxFit.cover)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: white),
                                child: Text("${dresses[index]["rating"]} ★", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(color: white, border: dresses[index]["premium"] ? Border.all(color: gold, width: 2) : null),
                                child: Row(
                                  children: <Widget>[
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: gold, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))),
                                      child: const Icon(FontAwesome.crown_solid, color: white, size: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(color: pink, borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(FontAwesome.database_solid, color: white, size: 15),
                            ),
                            const SizedBox(height: 10),
                            Text("Installment Available", style: GoogleFonts.abel(color: pink, fontSize: 8, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                              Text(dresses[index]["title"], style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(dresses[index]["owner"], style: GoogleFonts.abel(color: dark, fontSize: 10, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            Text("🗺️ ${dresses[index]["location"]}", style: GoogleFonts.abel(color: dark, fontSize: 7, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              child: Text("${dresses[index]["price"].toStringAsFixed(3).replaceAll(".", ",")} TND", style: GoogleFonts.abel(color: pink, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
