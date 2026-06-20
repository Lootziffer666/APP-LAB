# APP-LAB — The Forge

**80 Micro-Apps → 1 Engine.**

A monorepo containing the complete reduction of ~80 micro-app ideas into a single
engine-driven system. One Item type. One Status Engine. One Design System (FLUBBER).
Each "app" is just a Profile (a weight vector + view config).

## Structure

```
APP-LAB/
├── PLAN.md                  — Full top-down reduction plan
├── one-engine-test.js       — Original proof-of-concept (Node.js, 7 cases)
├── forge_core/              — Pure Dart engine (M0, done + 29 tests green)
│   ├── lib/src/
│   │   ├── item.dart        — Universal record type
│   │   ├── signals.dart     — 4 signals + extensible registry
│   │   ├── status_engine.dart — Weighted mix → bucket + driver
│   │   ├── transitions.dart — Pure state verbs (complete/snooze/reset/...)
│   │   ├── profile.dart     — "App" as data
│   │   └── store.dart       — Local-first persistence contract
│   └── test/                — 29 passing tests
└── the_forge/               — Flutter app (M1)
    ├── lib/
    │   ├── main.dart + app.dart
    │   ├── shell/           — Navigation drawer (7 profiles)
    │   ├── views/           — list, board, grid, bigButton
    │   ├── widgets/         — ItemCard (w/ BorderBeam), StatusChip, AddSheet
    │   ├── profiles/        — 7 profiles (pure config, zero engine code)
    │   ├── state/           — Riverpod + JSON persistence + demo seed
    │   ├── theme/           — FLUBBER tokens + ForgeDesignBridge
    │   └── animations/      — BorderBeam, PressRipple, ScrollReveal, ArchiveGravity
    └── pubspec.yaml
```

## Key Insight

> A micro-app is not defined by its THEME, but by its STATE MACHINE.
> Plant watering, contract cancellation, screw inventory, document retention,
> kids routines — all are the same engine with different weight vectors.

Proven in `one-engine-test.js` (Node) and `forge_core/test/` (Dart, 29 tests).

## Design System

Built on [FLUBBER](https://github.com/lootziffer666/FLUBBER) — the same
elastic/liquid motion grammar used in [KYUUBI](https://github.com/lootziffer666/KYUUBI).

## Getting Started

```bash
cd the_forge
flutter pub get
flutter run
```

## Profiles (each is ~20 lines of config, zero new engine code)

| Profile | Weights | View | What it replaces |
|---------|---------|------|-----------------|
| Deadline Ledger | `{time:1}` | list | Contract tracker, subscription tracker, TÜV reminder |
| Plant Care | `{time:1}` | list | Plant watering apps |
| Medication | `{time:0.6, stock:0.4}` | list | Med intake + supply tracker (sold as 2 apps elsewhere) |
| Household Inventory | `{stock:1}` | grid | Tool/screw/battery inventory apps |
| Kitchen Loop | `{stock:0.5, time:0.5}` | grid | Fridge tracker, expiry apps |
| Routine Engine | `{progress:1}` | board | Morning routine, cleaning plan, ADHD aids |
| Document Brain | `{retention:1}` | list | Invoice archive, retention period trackers |

## Pricing

99 ct (or 5 € lifetime). No ads, no tracking, no server, no subscription.
Your data is a JSON file on your device. Export it anytime.
