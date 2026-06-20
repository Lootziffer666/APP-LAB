/// The Forge — UI-free core (M0).
///
/// Frozen contracts: everything the 80 "apps" share. No Flutter, no skins.
/// An "app" is a [Profile] (pure data) over the single [Item] + [StatusEngine].
library forge_core;

export 'src/item.dart';
export 'src/signals.dart';
export 'src/status_engine.dart';
export 'src/transitions.dart';
export 'src/profile.dart';
export 'src/store.dart';
