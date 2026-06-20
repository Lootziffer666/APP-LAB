import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/forge_state.dart';
import '../theme/forge_colors.dart';

/// Export/Import UI sheet.
/// Export: copies full JSON to clipboard (or shares via system share sheet).
/// Import: paste JSON or pick a file.
class ExportImportSheet extends ConsumerWidget {
  const ExportImportSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ForgeColors.muted.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Daten verwalten',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Deine Daten gehören dir. Exportiere alles als JSON-Datei '
              'oder importiere ein Backup.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // Export button
            FilledButton.icon(
              onPressed: () => _export(context, ref),
              icon: const Icon(Icons.upload_rounded),
              label: const Text('Export (JSON in Zwischenablage)'),
            ),
            const SizedBox(height: 12),
            // Import button
            OutlinedButton.icon(
              onPressed: () => _import(context, ref),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Import (JSON aus Zwischenablage)'),
            ),
            const SizedBox(height: 12),
            // Item count info
            Consumer(builder: (_, ref, __) {
              final count = ref.watch(storeProvider).length;
              return Text(
                '$count Element${count == 1 ? '' : 'e'} gespeichert.',
                style: TextStyle(
                  fontSize: 12,
                  color: ForgeColors.muted.withAlpha(150),
                ),
                textAlign: TextAlign.center,
              );
            }),
          ],
        ),
      ),
    );
  }

  void _export(BuildContext context, WidgetRef ref) {
    final json = ref.read(storeProvider.notifier).exportAll();
    Clipboard.setData(ClipboardData(text: json));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('JSON in Zwischenablage kopiert.'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  void _import(BuildContext context, WidgetRef ref) async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text == null || data!.text!.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zwischenablage ist leer.')),
        );
      }
      return;
    }

    // Confirm before overwriting
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Import bestätigen'),
        content: const Text(
          'Alle bestehenden Daten werden durch das Backup ersetzt. Fortfahren?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Importieren'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        ref.read(storeProvider.notifier).importAll(data.text!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Import erfolgreich.')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Import fehlgeschlagen: $e')),
          );
        }
      }
    }
  }
}
