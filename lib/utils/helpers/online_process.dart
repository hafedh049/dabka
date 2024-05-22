import 'package:dabka/utils/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlineProcess extends StatelessWidget {
  const OnlineProcess({super.key});
  final List<String> _steps = const <String>[
    "Select the payment method you prefer than click book now",
    "Select the day that you want, notice there will be some days hidden that you cannot select because the produit will not be available",
    "Drag the clock to change the hours, notice there will be some hours hidden that you cannot select because the doctors will take a time to response",
    "The last step here you will see the date you selected and when you click next then its done, you will receive a reminder",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Online processing", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        for (int index = 1; index <= 4; index += 1) ...<Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Step $index", style: GoogleFonts.abel(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Image.asset("assets/images/step$index.png", fit: BoxFit.cover)),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.all(8),
                          color: dark.withOpacity(.1),
                          child: Text(_steps[index - 1], style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index < 4) const SizedBox(height: 20),
            ],
          )
        ],
      ],
    );
  }
}
