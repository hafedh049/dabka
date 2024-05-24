import 'package:cached_network_image/cached_network_image.dart';
import 'package:dabka/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../shared.dart';

class HomeSellers extends StatelessWidget {
  const HomeSellers({super.key, required this.sellers});
  final List<UserModel> sellers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(alignment: Alignment.centerRight, child: Text("Sellers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        sellers.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 150,
                  height: 250,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: CachedNetworkImageProvider(sellers[index].userAvatar), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        sellers[index].username,
                        style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(FontAwesome.user_plus_solid, size: 10, color: white),
                            const SizedBox(width: 5),
                            Text("★ Follow ★", style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
                itemCount: sellers.length,
              ),
      ],
    );
  }
}
