import 'package:dabka/models/user_account_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key, required this.supplier});
  final UserModel supplier;
  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
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
                Card(
                  borderOnForeground: true,
                  color: white,
                  elevation: 6,
                  shadowColor: dark,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.supplier.userRating.toStringAsFixed(1), style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 10, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 5),
                        for (int index = 0; index < widget.supplier.userRating.ceil(); index++) ...<Widget>[
                          Icon(FontAwesome.star, size: 10, color: purple),
                          if (index != widget.supplier.userRating.ceil() - 1) const SizedBox(width: 5),
                        ],
                      ],
                    ),
                  ),
                ),
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
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(15)),
            child: ListView.separated(itemBuilder: (BuildContext context, int index) => Container(), separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20), itemCount: ,),
          ),
        ],
      ),
    );
  }
}
