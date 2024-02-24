import 'package:fitend_trainer_app/app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flavors.dart';

Future<void> main() async {
  F.appFlavor = Flavor.production;
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
