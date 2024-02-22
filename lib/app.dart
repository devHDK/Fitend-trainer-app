import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/provider/shared_preference_provider.dart';
import 'package:fitend_trainer_app/common/secure_storage/secure_storage.dart';
import 'package:fitend_trainer_app/trainer/provider/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'flavors.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    initSharedPref(); //sharedPreferences 세팅
  }

  void initSharedPref() async {
    //sharedPreferences 세팅
    final pref = await ref.read(sharedPrefsProvider);

    if (pref.getBool(StringConstants.isFirstRunThread) ?? true) {
      pref.setBool(StringConstants.isFirstRunThread, true);
    }

    //처음 시작이면
    if (pref.getBool('first_run') ?? true) {
      final storage = ref.read(secureStorageProvider);

      await storage.deleteAll();

      pref.setBool('first_run', false);
    }

    Future.wait([
      pref.setBool(StringConstants.needScheduleUpdate, false),
      pref.setBool(StringConstants.needNotificationUpdate, false),
      pref.setStringList(StringConstants.needThreadUpdateUserList, []),
      pref.setStringList(StringConstants.needThreadUpdateList, []),
      pref.setStringList(StringConstants.needThreadDelete, []),
      pref.setStringList(StringConstants.needCommentCreate, []),
      pref.setStringList(StringConstants.needCommentDelete, []),
      pref.setStringList(StringConstants.needEmojiCreate, []),
      pref.setStringList(StringConstants.needEmojiDelete, []),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(routerProvider);

    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MaterialApp.router(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!,
            );
          },
          title: F.title,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "Pretendard",
            appBarTheme: const AppBarTheme(
              color: Pallete.background,
              elevation: 0,
            ),
            scaffoldBackgroundColor: Pallete.background,
            splashColor: Pallete.background,
          ),
          routerConfig: route,
        );
      },
    );
  }
}
