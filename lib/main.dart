import 'package:dabka/translations/translation.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

import 'views/onboarding/onboarding_holder.dart';
import 'views/client/holder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  await init();
  runApp(Main());
}

class Main extends StatelessWidget {
  Main({super.key});
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      locale: Locale(settingsBox!.get('language')),
      fallbackLocale: const Locale('ar', 'AR'),
      translations: Translation(),
      home: settingsBox!.get("first_time") ? const Onboarding() : const Holder(),
      debugShowCheckedModeBanner: false,
    );
  }
}
