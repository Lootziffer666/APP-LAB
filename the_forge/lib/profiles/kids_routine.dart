import 'package:forge_core/forge_core.dart';

/// Kids Routine — visual step-by-step for children (ADHD-friendly).
/// Same engine as routine_engine. BigButton view for large, tappable steps.
final kidsRoutine = Profile(
  id: 'kids_routine',
  title: 'Kinder-Routine',
  view: ViewId.bigButton,
  defaultWeights: const {'progress': 1},
  fields: const [
    FieldSpec('steps', 'Schritte', 'steps', required: true),
  ],
  actions: const ['toggleStep', 'reset'],
  filter: (item) =>
      item.state == ItemState.active && item.type == 'kids_routine',
  skin: const {
    'icon': 'child_care',
    'emptyLottie': 'assets/lottie/play.json',
  },
);
