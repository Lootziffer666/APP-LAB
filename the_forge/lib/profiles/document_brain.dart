import 'package:forge_core/forge_core.dart';

/// Local Document Brain profile.
/// Invoices, receipts, contracts, retention periods — all one archive.
final documentBrain = Profile(
  id: 'document_brain',
  title: 'Dokumente',
  view: ViewId.list,
  defaultWeights: const {'retention': 1},
  fields: const [
    FieldSpec('archiveDate', 'Aufbewahrungsfrist bis', 'date', required: true),
    FieldSpec('warnDays', 'Vorwarnung (Tage)', 'int'),
    FieldSpec('file', 'Datei', 'file'),
    FieldSpec('category', 'Kategorie', 'text'),
  ],
  actions: const ['archive', 'snooze'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'document_brain',
  skin: const {
    'icon': 'description',
    'emptyLottie': 'assets/lottie/empty_archive.json',
  },
);
