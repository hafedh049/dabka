import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

import 'shared.dart';

Future<bool> init() async {
  Hive.init((await getApplicationDocumentsDirectory()).path);
  settingsBox = await Hive.openBox('settings');
  if (settingsBox!.isEmpty) {
    await settingsBox!.putAll(
      <String, dynamic>{
        "first_time": true,
        "theme": "light",
        "language": "ar",
      },
    );
  }
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDyv0OGE2Wx8DjmclF2IL346kPFyTHFzvs',
      appId: '1:96485031528:android:85e4ffecda18ab498945dd',
      messagingSenderId: '96485031528',
      projectId: 'dabka-5aec6',
      storageBucket: 'dabka-5aec6.appspot.com',
    ),
  );
  return true;
}

void showToast(BuildContext context, String message, {Color color = purple}) {
  toastification.show(
    context: context,
    padding: const EdgeInsets.all(6),
    title: Text("Notification".tr, style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
    description: Text(message, style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500, color: dark)),
    autoCloseDuration: 2.seconds,
  );
}

String formatDuration(int durationInSeconds) {
  final int minutes = durationInSeconds ~/ 60;
  final int seconds = durationInSeconds % 60;

  final String minutesStr = minutes.toString().padLeft(2, '0');
  final String secondsStr = seconds.toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}

String formatNumber(int number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(0)}B';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(0)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(0)}K';
  } else {
    return number.toString();
  }
}
