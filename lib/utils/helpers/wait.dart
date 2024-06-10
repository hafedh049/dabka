import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Wait extends StatelessWidget {
  const Wait({super.key, this.switcher = false});
  final bool switcher;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switcher ? const CircularProgressIndicator(color: purple) : LottieBuilder.asset("assets/lotties/wait.json", reverse: true),
        ),
      ),
    );
  }
}
