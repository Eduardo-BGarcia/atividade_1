import 'package:go_router/go_router.dart';
import '../screens/dashboard_screen.dart';
import '../screens/timer_screen.dart';
import '../screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/timer/:categoria',
      name: 'timer',
      builder: (context, state) {
        final String categoria = state.pathParameters['categoria'] ?? 'Sem categoria';
        return TimerScreen(categoria: categoria);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);