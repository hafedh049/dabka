import 'package:cached_network_image/cached_network_image.dart';
import 'package:dabka/models/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

import '../shared.dart';

class ExclusiveOffers extends StatelessWidget {
  const ExclusiveOffers({super.key, required this.exclusiveOffers});
  final List<OfferModel> exclusiveOffers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Exclusive Offers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset("assets/images/thumbnail1.png", fit: BoxFit.cover, height: 100, width: double.infinity)),
        const SizedBox(height: 10),
        exclusiveOffers.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ShadowOverlay(
                      shadowHeight: 150,
                      shadowWidth: 150,
                      shadowColor: pink.withOpacity(.2),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 200,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              image: exclusiveOffers[index].offerImage.isEmpty
                                  ? const DecorationImage(
                                      image: AssetImage("assets/images/thumbnail1.png"),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: CachedNetworkImageProvider(exclusiveOffers[index].offerImage),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: Image.asset("assets/images/exclusive_offer.png", width: 150, height: 75, scale: 1.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  color: pink,
                                  padding: const EdgeInsets.all(2),
                                  child: Text(exclusiveOffers[index].offerName.toUpperCase(), style: GoogleFonts.abel(color: dark, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 10),
                                Text(exclusiveOffers[index].username, style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Container(
                                  color: pink,
                                  padding: const EdgeInsets.all(2),
                                  child: Text("${exclusiveOffers[index].offerDiscount.toStringAsFixed(0)} %", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 10),
                                ShaderMask(
                                  shaderCallback: (Rect bounds) => const LinearGradient(colors: <Color>[blue, green]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                  child: Text("CHECK OFFERS", style: GoogleFonts.abel(color: white, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
                  itemCount: exclusiveOffers.length,
                ),
              ),
      ],
    );
  }
}
