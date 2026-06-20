import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../state/forge_state.dart';
import '../theme/forge_colors.dart';

/// Bottom sheet for manually adding an item within a specific profile.
/// Fields are driven entirely by [Profile.fields] — no hardcoded forms.
class AddItemSheet extends ConsumerStatefulWidget {
  const AddItemSheet({super.key, required this.profile});

  final Profile profile;

  @override
  ConsumerState<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends ConsumerState<AddItemSheet> {
  final _titleCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _fieldValues = {};

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
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
              'Neues Element',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Title field (always present)
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Titel',
                hintText: 'z.B. Monstera gießen',
              ),
              autofocus: true,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
            ),
            const SizedBox(height: 12),
            // Profile-specific fields
            ...widget.profile.fields.map(_buildField),
            const SizedBox(height: 20),
            // Submit button
            FilledButton(
              onPressed: _submit,
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(FieldSpec field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: switch (field.kind) {
        'date' => _DateField(field: field, onChanged: (v) => _fieldValues[field.key] = v),
        'int' => TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: field.label),
            validator: field.required ? (v) => (v == null || v.isEmpty) ? 'Pflichtfeld' : null : null,
            onChanged: (v) => _fieldValues[field.key] = int.tryParse(v),
          ),
        'double' => TextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: field.label),
            validator: field.required ? (v) => (v == null || v.isEmpty) ? 'Pflichtfeld' : null : null,
            onChanged: (v) => _fieldValues[field.key] = double.tryParse(v),
          ),
        'text' => TextFormField(
            decoration: InputDecoration(labelText: field.label),
            onChanged: (v) => _fieldValues[field.key] = v,
          ),
        _ => const SizedBox.shrink(), // steps, file — M2/M3
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final attrs = <String, Object?>{};
    for (final entry in _fieldValues.entries) {
      if (entry.value != null) {
        // Convert date to epoch millis if stored as DateTime
        if (entry.value is DateTime) {
          attrs[entry.key] = (entry.value as DateTime).millisecondsSinceEpoch;
        } else {
          attrs[entry.key] = entry.value;
        }
      }
    }

    ref.read(storeProvider.notifier).addItem(
          title: _titleCtrl.text.trim(),
          type: widget.profile.id,
          attrs: attrs,
          weights: widget.profile.defaultWeights,
        );

    Navigator.pop(context);
  }
}

/// Simple date picker field that stores a DateTime.
class _DateField extends StatefulWidget {
  const _DateField({required this.field, required this.onChanged});

  final FieldSpec field;
  final ValueChanged<DateTime?> onChanged;

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 7)),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
        );
        if (date != null) {
          setState(() => _selected = date);
          widget.onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.field.label,
          suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
        ),
        child: Text(
          _selected != null
              ? '${_selected!.day}.${_selected!.month}.${_selected!.year}'
              : 'Datum wählen',
          style: TextStyle(
            color: _selected != null ? null : ForgeColors.muted,
          ),
        ),
      ),
    );
  }
}
