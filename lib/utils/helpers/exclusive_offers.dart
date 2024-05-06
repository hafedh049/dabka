import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

import '../shared.dart';

class ExclusiveOffers extends StatelessWidget {
  const ExclusiveOffers({super.key, required this.exclusiveOffers});
  final List<Map<String, dynamic>> exclusiveOffers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Exclusive Offers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset("assets/images/exclusive_offers.png", fit: BoxFit.cover),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) => Stack(
            children: <Widget>[
              Container(
                width: 200,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(image: AssetImage(exclusiveOffers[index]["image"]), fit: BoxFit.cover),
                ),
                child: Image.asset("assets/images/exclusive_offers.png", fit: BoxFit.cover, height: 40),
              ),
              ShadowOverlay(
                shadowHeight: 250,
                shadowWidth: 200,
                shadowColor: pink.withOpacity(.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(exclusiveOffers[index]["owner_name"], style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      color: pink,
                      padding: const EdgeInsets.all(2),
                      child: Text(exclusiveOffers[index]["discount"], style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    ShaderMask(
                      shaderCallback: (Rect bounds) => const LinearGradient(colors: <Color>[blue, pink]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      child: Text("CHECK OFFERS", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
          itemCount: exclusiveOffers.length,
        ),
      ],
    );
  }
}
