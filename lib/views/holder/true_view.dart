import 'package:dabka/models/true_view_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

class TrueView extends StatefulWidget {
  const TrueView({super.key});

  @override
  State<TrueView> createState() => _TrueViewState();
}

class _TrueViewState extends State<TrueView> {
  final List<List<TrueViewModel>> _trueViews = <List<TrueViewModel>>[];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) => Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ShadowOverlay(
                shadowHeight: 250,
                shadowWidth: 250,
                shadowColor: pink,
                child: Container(
                  width: 250,
                  height: 350,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: <Color>[pink, white.withOpacity(.3)]),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(_trueViews[index][0].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        Text(_trueViews[index][0].category, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("${_trueViews[index][0].price.toStringAsFixed(2).replaceAll(".", ",")} TND", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            CircleAvatar(radius: 10, backgroundImage: AssetImage(_trueViews[index][0].reelUrl)),
                            const SizedBox(width: 10),
                            Text(_trueViews[index][0].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_trueViews[index].length > 1) ...<Widget>[
            const SizedBox(width: 20),
            Stack(
              children: <Widget>[
                ShadowOverlay(
                  shadowHeight: 250,
                  shadowWidth: 250,
                  shadowColor: pink,
                  child: Container(
                    width: 250,
                    height: 350,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: <Color>[pink, white.withOpacity(.3)]),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(_trueViews[index][1].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                          ),
                          const Spacer(),
                          Text(_trueViews[index][1].category, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text("${_trueViews[index][1].price.toStringAsFixed(2).replaceAll(".", ",")} TND", style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              CircleAvatar(radius: 10, backgroundImage: AssetImage(_trueViews[index][0].reelUrl)),
                              const SizedBox(width: 10),
                              Text(_trueViews[index][1].category, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
      itemCount: _trueViews.length,
    );
  }
}
