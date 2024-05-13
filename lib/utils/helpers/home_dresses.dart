import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../shared.dart';

class HomeDresses extends StatelessWidget {
  const HomeDresses({super.key, required this.dresses});
  final List<Map<String, dynamic>> dresses;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(alignment: Alignment.centerRight, child: Text("فساتين", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset("assets/images/thumbnail1.png", fit: BoxFit.cover, height: 80)),
        const SizedBox(height: 10),
        dresses.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) => Stack(
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
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
                itemCount: dresses.length,
              ),
      ],
    );
  }
}
