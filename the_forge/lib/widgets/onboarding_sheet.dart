import 'package:flutter/material.dart';

import '../profiles/profile_registry.dart';
import '../theme/forge_colors.dart';

/// Onboarding: "Wähle deine Module".
/// Shown on first launch (or via settings). Lets user toggle profiles on/off.
/// For M3 this stores selection in SharedPreferences; the registry
/// filters based on selection.
class OnboardingSheet extends StatefulWidget {
  const OnboardingSheet({super.key, this.onDone});

  final VoidCallback? onDone;

  @override
  State<OnboardingSheet> createState() => _OnboardingSheetState();
}

class _OnboardingSheetState extends State<OnboardingSheet> {
  // All profiles start as selected
  late final Map<String, bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final p in allProfiles) p.id: true,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'Willkommen bei The Forge',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Wähle die Module, die du nutzen möchtest. '
              'Du kannst das jederzeit in den Einstellungen ändern.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Profile toggles
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final p in allProfiles)
                    CheckboxListTile(
                      value: _selected[p.id] ?? true,
                      onChanged: (v) =>
                          setState(() => _selected[p.id] = v ?? true),
                      title: Text(p.title),
                      subtitle: Text(
                        _profileDescription(p.id),
                        style: TextStyle(
                          fontSize: 12,
                          color: ForgeColors.muted.withAlpha(150),
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // TODO M4: persist selection to SharedPreferences
                // and filter allProfiles accordingly
                widget.onDone?.call();
                Navigator.pop(context);
              },
              child: Text(
                '${_selected.values.where((v) => v).length} Module aktivieren',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _profileDescription(String id) => switch (id) {
        'deadline_ledger' => 'Termine, Fristen, Kündigungen',
        'calendar_overview' => 'Alles auf einen Blick im Kalender',
        'contract_tracker' => 'Verträge & Abo-Kosten',
        'warranty_tracker' => 'Garantien & Kaufbelege',
        'plant_care' => 'Gießen, Düngen, Umtopfen',
        'cleaning_plan' => 'Regelmäßige Putz-Aufgaben',
        'medication_tracker' => 'Einnahme + Vorrat',
        'household_inventory' => 'Was habe ich, wo liegt es',
        'kitchen_loop' => 'Kühlschrank, Vorrat, Haltbarkeit',
        'routine_engine' => 'Routinen, Checklisten, Abläufe',
        'kids_routine' => 'Morgenroutine für Kinder (ADHD-freundlich)',
        'document_brain' => 'Dokumente & Aufbewahrungsfristen',
        'senior_contacts' => 'Große Buttons, wenige Funktionen',
        _ => '',
      };
}
