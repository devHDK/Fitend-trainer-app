import 'dart:io';

import 'package:fitend_trainer_app/common/component/logo_appbar.dart';
import 'package:fitend_trainer_app/common/const/aseet_constants.dart';
import 'package:fitend_trainer_app/common/const/pallete.dart';
import 'package:fitend_trainer_app/common/provider/avail_camera_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home_screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  // final GlobalKey<ScheduleScreenState> scheduleScreenKey = GlobalKey();
  // final GlobalKey<ThreadScreenState> threadScreenKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AsyncValue<List<CameraDescription>> camerasAsyncValue =
    ref.watch(availableCamerasProvider);

    return WillPopScope(
      onWillPop: () async => false,
      child: ScrollsToTop(
        onScrollsToTop: (event) async {},
        child: Scaffold(
          backgroundColor: Pallete.background,
          appBar: LogoAppbar(
            title: _currentIndex == 0 ? 'P L A N' : 'T H R E A D S',
            tapLogo: () {},
          ),
          bottomNavigationBar: BottomAppBar(
            color: Pallete.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 1,
                  color: Pallete.gray,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            _currentIndex = 0;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: SvgPicture.asset(
                          _currentIndex == 0
                              ? SVGConstants.scheduleActive
                              : SVGConstants.schedule,
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Pallete.gray,
                      width: 1, // specify the width of the divider
                    ),
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            _currentIndex = 1;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: SvgPicture.asset(
                          _currentIndex == 1
                              ? SVGConstants.messageActive
                              : SVGConstants.message,
                        ),
                      ),
                    ),
                  ],
                ),
                if (Platform.isAndroid)
                  const SizedBox(
                    height: 10,
                  ),
              ],
            ),
          ),
          body: const SizedBox(),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
