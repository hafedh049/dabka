import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
        Text("عروض حصرية", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset("assets/images/thumbnail1.png", fit: BoxFit.cover, height: 80)),
        const SizedBox(height: 10),
        exclusiveOffers.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 160,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(exclusiveOffers[index]["image"]), fit: BoxFit.cover),
                          ),
                          child: Image.asset("assets/images/exclusive_offer.png", width: 150, height: 75, scale: 1.5),
                        ),
                        ShadowOverlay(
                          shadowHeight: 160,
                          shadowWidth: 150,
                          shadowColor: pink.withOpacity(.3),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Spacer(),
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
                                  child: Text("التحقق من العروض", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
