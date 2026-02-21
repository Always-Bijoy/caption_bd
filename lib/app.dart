import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/generating_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/success_screen.dart';
import 'screens/workspace_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: '/workspace',
      builder: (_, __) => const WorkspaceScreen(),
    ),
    GoRoute(
      path: '/generating',
      builder: (_, __) => const GeneratingScreen(),
    ),
    GoRoute(
      path: '/success',
      builder: (_, __) => const SuccessScreen(),
    ),
  ],
);
