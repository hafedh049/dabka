import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

import '../shared.dart';

class InstallmentOffers extends StatelessWidget {
  const InstallmentOffers({super.key, required this.installmentOffers});
  final List<Map<String, dynamic>> installmentOffers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Installment Offers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset("assets/images/nh.jpg", fit: BoxFit.cover),
        ),
        const SizedBox(height: 10),
        installmentOffers.isEmpty
            ? Center(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true, width: 100, height: 100))
            : SizedBox(
                height: 200,
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) => Stack(
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        child: const SizedBox(),
                      ),
                      ShadowOverlay(
                        shadowHeight: 250,
                        shadowWidth: 150,
                        shadowColor: pink.withOpacity(.1),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          width: 150,
                          height: 200,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(installmentOffers[index]["category"], style: GoogleFonts.abel(color: white, fontSize: 25, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: blue, width: 5),
                                  image: DecorationImage(image: AssetImage(installmentOffers[index]["image"]), fit: BoxFit.cover),
                                ),
                              ),
                              const Spacer(),
                              ShaderMask(
                                shaderCallback: (Rect bounds) => const LinearGradient(colors: <Color>[blue, pink]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                child: Container(
                                  color: pink,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(installmentOffers[index]["payment"], style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
                  itemCount: installmentOffers.length,
                ),
              ),
      ],
    );
  }
}
