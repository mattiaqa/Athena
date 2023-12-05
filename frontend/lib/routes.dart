import 'package:flutter/material.dart';
import 'package:frontend/Screens/Libretto/libretto_main.dart';
import 'package:frontend/Screens/Appelli/appelli_main.dart';
import 'package:frontend/Screens/Menu/menu_main.dart';
import 'package:frontend/Screens/Prenotazioni/prenotazioni_main.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'Login',
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage
      (
        transitionDuration: const Duration(milliseconds: 200),
        key: state.pageKey,
        child: LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition
        (
          opacity: animation, 
          child: child,
        ),
      ),
    ),

    GoRoute
    (
      name: "Menu",
      path: '/menu',
      pageBuilder: (context, state){
      return CustomTransitionPage
      (
        transitionDuration: const Duration(milliseconds: 200),
        key: state.pageKey,
        child: Menu(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition
          (
            opacity: animation,
            child: child,
          ) 
      );}
    ),

    GoRoute(
      name: 'Libretto',
      path: '/libretto',
      builder: (context, state) => Libretto(),
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'Appelli',
      path: '/appelli',
      builder: (context, state) => Appelli(),
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'Bacheca prenotazioni',
      path: '/prenotazioni',
      builder: (context, state) => Prenotazioni(),
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'Logout',
      path: '/logout',
      builder: (context, state) => Prenotazioni(),
      redirect: (context, state) => _redirect(context, state),
    ),
  ],
);

String? _redirect(BuildContext context, GoRouterState state) {
  return (AuthService.isAuthenticated) ? null : null;
}
