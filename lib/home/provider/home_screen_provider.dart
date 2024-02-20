import 'package:fitend_trainer_app/home/model/home_screen_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeStateProvider =
    StateNotifierProvider<HomeScreenStateNotifier, HomeScreenStateModel>((ref) {
  return HomeScreenStateNotifier();
});

class HomeScreenStateNotifier extends StateNotifier<HomeScreenStateModel> {
  HomeScreenStateNotifier()
      : super(
          HomeScreenStateModel(tabIndex: 0),
        );

  void changeTapIndex(int index) {
    final pstate = state;

    pstate.tabIndex = index;

    state = pstate.copyWith();
  }
}
