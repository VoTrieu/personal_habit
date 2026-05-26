import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../habits/habits_screen.dart';
import '../insights/insights_screen.dart';
import '../profile/profile_screen.dart';
import '../today/today_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  int selectedIndex = 0;
  String? loadedDateKey;
  Timer? dailyRefreshTimer;

  final pages = const [
    TodayScreen(),
    HabitsScreen(),
    InsightsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadedDateKey ??= context.read<HabitController>().todayKey();
    scheduleDailyRefresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshIfDateChanged();
    }
  }

  @override
  void dispose() {
    dailyRefreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Habits',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void scheduleDailyRefresh() {
    dailyRefreshTimer?.cancel();

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    dailyRefreshTimer = Timer(tomorrow.difference(now), refreshForNewDay);
  }

  Future<void> refreshIfDateChanged() async {
    final todayKey = context.read<HabitController>().todayKey();
    if (loadedDateKey == todayKey) return;

    await refreshForNewDay();
  }

  Future<void> refreshForNewDay() async {
    if (!mounted) return;

    loadedDateKey = context.read<HabitController>().todayKey();
    await context.read<HabitController>().loadHabits();

    if (mounted) {
      scheduleDailyRefresh();
    }
  }
}
