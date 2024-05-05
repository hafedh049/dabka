import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/holder/holder.dart';
import 'views/onboarding/onboarding_holder.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FutureBuilder<void>(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasData) {
            return settingsBox.get("first_time") ? const Onboarding() : const Holder();
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
