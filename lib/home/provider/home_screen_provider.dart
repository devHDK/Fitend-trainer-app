import 'package:fitend_trainer_app/home/model/home_screen_state_model.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_home_screen_provider.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeStateProvider =
    StateNotifierProvider<HomeScreenStateNotifier, HomeScreenStateModel>((ref) {
  final notiProvider = ref.read(notificationProvider.notifier);
  final notiHomeProvider = ref.read(notificationHomeProvider.notifier);

  return HomeScreenStateNotifier(
    notiProvider: notiProvider,
    notiHomeProvider: notiHomeProvider,
  );
});

class HomeScreenStateNotifier extends StateNotifier<HomeScreenStateModel> {
  final NotificationStateNotifier notiProvider;
  final NotificationHomeStateNotifier notiHomeProvider;

  HomeScreenStateNotifier({
    required this.notiProvider,
    required this.notiHomeProvider,
  }) : super(
          HomeScreenStateModel(tabIndex: 0),
        );

  void changeTapIndex(int index) {
    final pstate = state;

    if (pstate.tabIndex == 2 && index != 2) {
      if (mounted) {
        notiProvider.putNotification();
        notiHomeProvider.updateIsConfirm(true);
      }
    }

    pstate.tabIndex = index;

    state = pstate.copyWith();
  }
}
