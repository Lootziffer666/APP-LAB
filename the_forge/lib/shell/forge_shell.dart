import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../profiles/profile_registry.dart';
import '../views/profile_view.dart';

/// The Forge Shell — the "Regal" that hosts all profiles.
/// Uses a drawer for navigation when there are more than 5 profiles,
/// bottom nav when 5 or fewer.
class ForgeShell extends ConsumerStatefulWidget {
  const ForgeShell({super.key});

  @override
  ConsumerState<ForgeShell> createState() => _ForgeShellState();
}

class _ForgeShellState extends ConsumerState<ForgeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profiles = allProfiles;
    final useDrawer = profiles.length > 5;

    return Scaffold(
      drawer: useDrawer ? _buildDrawer(profiles) : null,
      body: ProfileView(
        key: ValueKey(profiles[_currentIndex].id),
        profile: profiles[_currentIndex],
      ),
      bottomNavigationBar: useDrawer
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) =>
                  setState(() => _currentIndex = i),
              destinations: [
                for (final p in profiles)
                  NavigationDestination(
                    icon: Icon(_iconForProfile(p)),
                    label: p.title,
                  ),
              ],
            ),
    );
  }

  Widget _buildDrawer(List<Profile> profiles) {
    return NavigationDrawer(
      selectedIndex: _currentIndex,
      onDestinationSelected: (i) {
        setState(() => _currentIndex = i);
        Navigator.pop(context);
      },
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 16, 8),
          child: Text(
            'The Forge',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 0, 16, 16),
          child: Text(
            '80 Apps. 1 Engine.',
            style: TextStyle(fontSize: 12, letterSpacing: 0.5),
          ),
        ),
        const Divider(indent: 28, endIndent: 28),
        for (final p in profiles)
          NavigationDrawerDestination(
            icon: Icon(_iconForProfile(p)),
            label: Text(p.title),
          ),
      ],
    );
  }

  IconData _iconForProfile(Profile profile) {
    final iconName = (profile.skin['icon'] as String?) ?? 'apps';
    return switch (iconName) {
      'calendar_today' => Icons.calendar_today_rounded,
      'inventory_2' => Icons.inventory_2_rounded,
      'checklist' => Icons.checklist_rounded,
      'medication' => Icons.medication_rounded,
      'kitchen' => Icons.kitchen_rounded,
      'eco' => Icons.eco_rounded,
      'description' => Icons.description_rounded,
      _ => Icons.apps_rounded,
    };
  }
}
