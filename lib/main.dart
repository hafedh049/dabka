import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'views/onboarding/onboarding_holder.dart';
import 'views/supplier/holder/holder.dart';

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
            return !settingsBox!.get("first_time")
                ? const Onboarding()
                : FutureBuilder<UserCredential>(
                    future: FirebaseAuth.instance.signInWithEmailAndPassword(email: 'hafedhgunichi@gmail.com', password: '20012002HN*'),
                    builder: (BuildContext context, AsyncSnapshot<UserCredential> snap) {
                      if (snap.hasData) {
                        return const Holder();
                      } else if (snap.connectionState == ConnectionState.waiting) {
                        return const Wait();
                      } else {
                        return ErrorScreen(error: snap.error.toString());
                      }
                    },
                  );
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
