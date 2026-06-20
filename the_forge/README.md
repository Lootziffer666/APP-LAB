# The Forge

**80 Apps → 1 Engine.** Local-first, gesture-driven, powered by FLUBBER.

## What this is

A single app that replaces ~80 micro-apps (plant watering, contract tracking,
screw inventory, document retention, kids routines, medication, ...) with one
engine and interchangeable profiles.

Every "app" is just a weight vector: `{time: 0.6, stock: 0.4}`.
No server. No login. No subscription.

## Architecture

```
┌─────────────────────────────────────────┐
│  the_forge/  (Flutter App)              │
│  ├── shell/      — Navigation/Regal     │
│  ├── views/      — ProfileView          │
│  ├── widgets/    — ItemCard, AddSheet    │
│  ├── profiles/   — "Apps" as config     │
│  ├── state/      — Riverpod + persist   │
│  └── theme/      — FLUBBER tokens       │
└──────────────────┬──────────────────────┘
                   │ depends on
┌──────────────────▼──────────────────────┐
│  forge_core/  (Pure Dart, no Flutter)   │
│  ├── Item        — universal record     │
│  ├── Signals     — time/stock/progress/ │
│  │                 retention + registry  │
│  ├── Engine      — weighted mix→bucket  │
│  ├── Transitions — complete/snooze/...  │
│  ├── Profile     — "app" as data        │
│  └── Store       — local-first JSON     │
└─────────────────────────────────────────┘
```

## Design System

Inherits [FLUBBER](https://github.com/lootziffer666/FLUBBER):
- Dark-first, flat Vollton accents
- Liquid/elastic motion grammar
- Gesture-driven: swipe = complete, long-press = actions
- Status → color → motion intensity (automatic via ForgeDesignBridge)

## Pricing

99 ct (or 5 € lifetime). No ads, no tracking, no server, no subscription.
Your data is a JSON file on your device. Export it anytime.

## Status

- [x] M0 — Core engine (proven, tested)
- [ ] M1 — Deadline Ledger (vertical slice, release-ready)
- [ ] M2 — Inventory, Routines, Calendar views
- [ ] M3 — OCR capture, notifications, adapters
- [ ] M4 — Shell, global search, relations
- [ ] M5 — All 75+ profiles (pure config)
