import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../profiles/profile_registry.dart';
import '../views/profile_view.dart';
import '../widgets/search_sheet.dart';
import '../widgets/export_import_sheet.dart';
import '../widgets/onboarding_sheet.dart';

/// The Forge Shell — the "Regal" that hosts all profiles.
/// Uses a drawer for navigation (13+ profiles).
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

    return Scaffold(
      drawer: _buildDrawer(profiles),
      body: ProfileView(
        key: ValueKey(profiles[_currentIndex].id),
        profile: profiles[_currentIndex],
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
          padding: EdgeInsets.fromLTRB(28, 24, 16, 4),
          child: Text(
            'The Forge',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 16, 8),
          child: Text(
            '${profiles.length} Module · 1 Engine',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
            ),
          ),
        ),
        const Divider(indent: 28, endIndent: 28),
        for (final p in profiles)
          NavigationDrawerDestination(
            icon: Icon(_iconForProfile(p)),
            label: Text(p.title),
          ),
        const Divider(indent: 28, endIndent: 28),
        // Utility actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.search_rounded),
            title: const Text('Suche'),
            onTap: () {
              Navigator.pop(context);
              _showSearch();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.import_export_rounded),
            title: const Text('Export / Import'),
            onTap: () {
              Navigator.pop(context);
              _showExportImport();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.tune_rounded),
            title: const Text('Module verwalten'),
            onTap: () {
              Navigator.pop(context);
              _showOnboarding();
            },
          ),
        ),
      ],
    );
  }

  void _showSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SearchSheet(),
    );
  }

  void _showExportImport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExportImportSheet(),
    );
  }

  void _showOnboarding() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const OnboardingSheet(),
    );
  }

  IconData _iconForProfile(Profile profile) {
    final iconName = (profile.skin['icon'] as String?) ?? 'apps';
    return switch (iconName) {
      'calendar_today' => Icons.calendar_today_rounded,
      'calendar_month' => Icons.calendar_month_rounded,
      'inventory_2' => Icons.inventory_2_rounded,
      'checklist' => Icons.checklist_rounded,
      'medication' => Icons.medication_rounded,
      'kitchen' => Icons.kitchen_rounded,
      'eco' => Icons.eco_rounded,
      'description' => Icons.description_rounded,
      'cleaning_services' => Icons.cleaning_services_rounded,
      'receipt_long' => Icons.receipt_long_rounded,
      'verified_user' => Icons.verified_user_rounded,
      'accessibility_new' => Icons.accessibility_new_rounded,
      'child_care' => Icons.child_care_rounded,
      'directions_car' => Icons.directions_car_rounded,
      'fitness_center' => Icons.fitness_center_rounded,
      'payments' => Icons.payments_rounded,
      'pets' => Icons.pets_rounded,
      'cake' => Icons.cake_rounded,
      _ => Icons.apps_rounded,
    };
  }
}
