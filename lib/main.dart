import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/admin/holder/holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'views/onboarding/onboarding_holder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FutureBuilder<bool>(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return !settingsBox!.get("first_time") ? const Onboarding() : const Holder();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Wait();
          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
