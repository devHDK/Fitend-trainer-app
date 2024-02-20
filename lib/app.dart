import 'package:fitend_trainer_app/common/const/pallete.dart';
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
          ),
          routerConfig: route,
        );
      },
    );
  }
}
