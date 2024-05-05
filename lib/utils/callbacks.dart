import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'shared.dart';

Future<void> init() async {
  Hive.init((await getApplicationDocumentsDirectory()).path);
  settingsBox = await Hive.openBox('settings');
  if (settingsBox.isEmpty) {
    await settingsBox.putAll(
      <String, dynamic>{
        "first_time": true,
        "theme": "light",
        "language": "en",
      },
    );
  }
}
