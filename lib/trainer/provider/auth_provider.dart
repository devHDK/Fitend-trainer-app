import 'package:fitend_trainer_app/common/view/error_screen.dart';
import 'package:fitend_trainer_app/common/view/onboarding_screen.dart';
import 'package:fitend_trainer_app/home_screen.dart';
import 'package:fitend_trainer_app/trainer/model/trainer_model.dart';
import 'package:fitend_trainer_app/trainer/provider/get_me_provider.dart';
import 'package:fitend_trainer_app/trainer/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<TrainerModelBase?>(
      getMeProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/onboard',
          name: OnBoardingScreen.routeName,
          builder: (context, state) => const OnBoardingScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          name: HomeScreen.routeName,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/error',
          name: ErrorScreen.routeName,
          builder: (context, state) => const ErrorScreen(),
        ),
      ];

  CustomTransitionPage<void> _fadeTransition(
      GoRouterState state, Widget widget) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  CustomTransitionPage<void> _botToTopTransiton(
      GoRouterState state, Widget widget) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(0, 2.0),
            end: Offset.zero,
          ).chain(
            CurveTween(curve: Curves.ease),
          ),
        ),
        child: child,
      ),
    );
  }

  CustomTransitionPage<void> _rightToLeftTransiton(
      GoRouterState state, Widget widget) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(1.0, 0),
            end: Offset.zero,
          ).chain(
            CurveTween(curve: Curves.ease),
          ),
        ),
        child: child,
      ),
    );
  }

  CustomTransitionPage buildPageWithDefaultTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
          Widget child) =>
      (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition<T>(
          context: context,
          state: state,
          child: child,
        );
      };

  Future<String?> redirectLogic(
      BuildContext context, GoRouterState state) async {
    final TrainerModelBase? trainer = ref.read(getMeProvider);

    final loginIn = state.uri.toString() == '/login';

    if (trainer == null) {
      return loginIn ? null : '/login';
    }

    //trainer != null
    //TrainerModel
    //로그인 중이거나 현재 위치가 onboardScreen이면 홈으로 이동
    if (trainer is TrainerModel) {
      return loginIn || state.uri.toString() == '/onboard' ? '/' : null;
    }

    if (trainer is TrainerModelError && trainer.statusCode == 444) {
      return null;
    }

    // getMe Error...
    if (trainer is TrainerModelError) {
      return loginIn && (trainer.statusCode != 504) ? '/login' : '/error';
    }

    return null;
  }
}
