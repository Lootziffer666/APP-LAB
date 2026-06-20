# The Forge — Top-Down Reduktionsplan (80 Apps → 1 System)

Bewiesen (siehe `one-engine-test.js` + `forge_core/`): Jede "Micro-App" ist ein
Gewichtsvektor über eine geteilte Entity-State-Engine. Dieser Plan geht
**rückwärts** vom fertigen Produkt zum minimal nötigen Primitiv-Set.

---

## 0. Zielzustand & Constraints

**Produkt:** Ein lokales, login-freies Programm ("The Forge").
Der Nutzer sieht ein Regal seiner Dinge → Status → Aktion → Erinnerung.
Quer über alle 80 Themen.

**Preis:** 99 ct (oder 5 € lifetime). Erzwingt:
- Kein Server, kein Auth → **local-first**
- Daten = reines JSON, offline lauffähig
- Kein Backend-Layer → eliminiert ~40 % des üblichen App-Aufwands

**Stack:** Flutter (KYUUBI-Codebasis) + FLUBBER Design System + Lottie.
Das Design System ist deployed, die Motion Grammar gebaut. The Forge erbt es.

---

## 1. Das minimale Primitiv-Set (rückwärts vom Ziel)

| # | Primitiv | Status |
|---|----------|--------|
| P1 | **Item** (universeller Datensatz) | ✅ implementiert (`forge_core`) |
| P2 | **Signals** (time, stock, progress, retention + Registry) | ✅ implementiert |
| P3 | **Status-Engine** (gewichteter Mix → bucket + driver) | ✅ implementiert + bewiesen |
| P4 | **Transitions** (complete, snooze, reset, archive, setQty, toggleStep) | ✅ implementiert |
| P5 | **Capture** (manuell / Datei+OCR / voice) | 🔲 M3 |
| P6 | **Actions/Adapter** (notify, applyPreset, launch, call) | 🔲 M3 |
| P7 | **Views** (list, calendar, board, grid, bigButton, launcher) | 🔲 M1–M2 |
| P8 | **Profile** (= "die App" als reine Daten) | ✅ Contract implementiert |
| P9 | **Store** (local-first JSON) | ✅ Contract + InMemory impl |
| P10 | **Shell** (The Forge: Regal, Navigation, Suche) | 🔲 M4 |

---

## 2. FLUBBER/KYUUBI → Forge: Was existiert, was fehlt

### 2.1 Bucket → Token → Animationskomponente (Mapping)

Die Engine liefert 4 Status-Buckets. Jeder Bucket mappt auf existierende
FLUBBER-Tokens und KYUUBI-Animationskomponenten:

| Bucket | Farbe (FLUBBER) | Motion (KYUUBI) | Intensität |
|--------|-----------------|-----------------|------------|
| `ok` | `--lime` / `KyuubiColors.green` | keine aktive Animation | ruhig |
| `soon` | `--cyan` / `KyuubiColors.flubberCyan` | `LuminousEnergyLine(mode: calm)` | sanft, langsam |
| `due` | `--orange` / `KyuubiColors.orange` | `LuminousEnergyLine(mode: pressure)` + `BorderBeam` | mittel |
| `critical` | `--coral` / `KyuubiColors.coral` | `LuminousEnergyLine(mode: urgent)` | schnell, pulsierend |

### 2.2 Transition → Motion (Mapping)

| Verb | Motion | Existiert |
|------|--------|-----------|
| complete | `GooeyButton` squish + item `ScrollReveal` raus (reverse) | ✅ |
| snooze | `diagonal_liquid_color_wipe` (Zustandswipe) | ✅ |
| reset | `liquid_blob_transition` (Reform-Morph) | ✅ |
| archive | Item fällt nach unten weg (gravity-feel) | 🔲 neu: ~30 Zeilen |
| toggleStep | Step-Zeile wippt (press_ripple per Zeile) | ✅ adaptierbar |
| setQty | `liquid_value_slider` (Bestand-Slider) | ✅ |

### 2.3 Was KYUUBI hat und The Forge direkt erbt

- `animations/` — 18 Flutter-Animationskomponenten, alle mit reduce-motion
- `theme/colors.dart` — FLUBBER-Palette bereits in Dart als `KyuubiColors`
- `theme/kyuubi_theme.dart` — ThemeData dark/light mit allen Tokens
- `widgets/status_chip.dart` — Status-Badges (anpassbar für Bucket-Labels)
- `animations/scroll_reveal.dart` — staggered list reveal
- `animations/gooey_button.dart` — complete/snooze/hold-to-confirm
- `animations/border_beam.dart` — ownership/claimed-Zustand → due/critical
- `animations/luminous_energy_line.dart` — Dringlichkeits-Gradient
- `animations/liquid_value_slider.dart` — Quantity-Input (Inventar)

### 2.4 Was NEU gebaut werden muss (The Forge-spezifisch)

| Komponente | Aufwand | Milestone |
|-----------|---------|-----------|
| `ForgeItemCard` (universelle Card für alle Profile) | mittel | M1 |
| `ForgeListView` (sortiert nach urgency, staggered reveal) | klein | M1 |
| `ForgeProfileShell` (eine App-View, angetrieben durch Profile) | mittel | M1 |
| `ForgeCalendarView` | mittel | M2 |
| `ForgeBoardView` (Routine Steps) | mittel | M2 |
| `ForgeGridView` (Inventory) | klein | M2 |
| `ForgeBigButtonView` (Senior/Kinder) | klein | M2 |
| `ForgeLauncherView` (Couch/Tools) | klein | M4 |
| `ForgeShell` (Regal + Profil-Navigation + Suche) | mittel | M4 |
| `archive`-Animation (gravity-out) | winzig | M1 |
| Capture Flow (manual entry bottom sheet) | klein | M1 |
| Capture Flow (file/OCR) | mittel | M3 |
| Notification Adapter (local_notifications) | klein | M3 |
| Persistent Store (path_provider + JSON / optional SQLite) | klein | M1 |

---

## 3. Eingefrorene Verträge (Seams)

Alle in `forge_core/lib/src/` — **bereits geschrieben und getestet:**

```
Item         — universeller Datensatz + JSON serialization + history
Signal       — reine Funktion (attrs, now) → 0..1
StatusEngine — evaluate(item, now) → {urgency, bucket, driver}
Transition   — pure Verb-Funktionen: complete, snooze, reset, archive, setQty, toggleStep
Profile      — "App" als Daten: {weights, view, fields, actions, filter, skin}
Store        — all, upsert, remove, export, import
```

**Neue Seam für Flutter-Seite (M1):**

```dart
/// Bucket → Design Token Mapping (the bridge between engine and FLUBBER)
abstract class ForgeDesignBridge {
  Color bucketColor(Bucket b);
  LuminousMode bucketMotion(Bucket b);
  Duration bucketAnimDuration(Bucket b);
  Curve bucketCurve(Bucket b);
}
```

Diese eine Klasse verbindet die Engine mit dem gesamten FLUBBER-System.
Steht sie, rendert jedes Item automatisch korrekt — unabhängig vom Thema.

---

## 4. Polish-Doktrin

1. **Ein Token-Set** → FLUBBER existiert, kein Erfinden.
2. **Eine Interaktions-Grammatik** → Status sieht überall gleich aus:
   - Bucket → Farbe → Motion-Intensität (bereits gemappt oben)
   - Wisch/Tap = complete (GooeyButton squish)
   - Long-press = snooze (diagonal wipe)
   - Überall. Gelernt einmal, gilt für alle 80.
3. **Shared Components** → aus KYUUBI: empty states, loading, error, toasts.
4. **Vertikaler Schnitt (M1) = Qualitätsstandard**, Breite erbt.

---

## 5. Baureihenfolge

### M0 — Kern (✅ DONE)
- `forge_core/` — Item, Signals, Engine, Transitions, Profile, Store
- Alle Tests grün, Dart Analyzer clean

### M1 — DER EINE VERTIKALE SCHNITT → Deadline Ledger, release-ready
**Ziel:** EIN Profil end-to-end, polished.
- [ ] Flutter-Projekt-Skeleton in `the_forge/`
- [ ] `forge_core` als path dependency einbinden
- [ ] `ForgeDesignBridge` implementieren (Bucket → FLUBBER Token)
- [ ] State Management: Riverpod Notifier über Store + Transitions
- [ ] `ForgeItemCard` — universelle Card mit bucket-farbigem Border/Beam
- [ ] `ForgeListView` — sortiert nach urgency, ScrollRevealList
- [ ] `ForgeProfileShell` — Scaffold, das ein Profile rendert
- [ ] Manual Capture BottomSheet (Titel + Datum + optionales Intervall)
- [ ] Persistent Store (path_provider + JSON file)
- [ ] Swipe = complete, Long-press = snooze (GooeyButton-Grammar)
- [ ] 1 Profil-Deklaration: `deadlineLedger`
- [ ] Polish-Pass: reduce-motion, empty state, toast für complete/snooze

### M2 — Weitere Views → beweist Profil-Abstraktion
- [ ] `ForgeCalendarView` (monthly dots, item list per day)
- [ ] `ForgeBoardView` (Routine: Steps als Checkliste, progress bar)
- [ ] `ForgeGridView` (Inventar: Foto-Kacheln + Qty Badge)
- [ ] `ForgeBigButtonView` (Senior/Kinder: max 6 große Kacheln)
- [ ] Profile: `householdInventory`, `morningRoutine`, `seniorContacts`
- [ ] Beweis: null neuer Kern-Code, nur Profile + Views

### M3 — Ränder
- [ ] Capture: file picker + on-device OCR (google_mlkit_text_recognition)
- [ ] Capture: voice memo → text → Item Draft
- [ ] Actions/Adapter: flutter_local_notifications → Reminder
- [ ] Actions/Adapter: OS-Preset (Couch Mode — brightness/audio intent)
- [ ] Profile: `documentBrain`, `brainDump`, `couchMode`

### M4 — Shell-Vollausbau
- [ ] `ForgeShell` — Profil-Registry als Launcher/Regal
- [ ] Globale Suche über alle Items (fuzzy match title + type)
- [ ] Export/Import UI (JSON share)
- [ ] Relationen-UI (Routine → Steps, Rezept → Zutaten)
- [ ] Onboarding: "Wähle deine Module" (Profile an/aus)

### M5 — Breite (reine Konfigurationsarbeit)
- [ ] Alle ~75 restlichen Profile als Deklarationen
- [ ] Skins pro Profil (icon, accent-color-override, Lottie empty-state)
- [ ] Store / Play Store submission
- [ ] Pricing: 99 ct einmalig / 5 € lifetime (kein Abo)

---

## 6. Technische Entscheidungen (fest)

| Entscheidung | Wahl | Warum |
|-------------|------|-------|
| Framework | Flutter | FLUBBER/KYUUBI-Designsystem liegt vor, deployed |
| State Mgmt | Riverpod (oder flutter_bloc) | Pure Notifier über forge_core Transitions |
| Kern | `forge_core` (reines Dart, null Flutter-Deps) | Testbar, teilbar, portierbar |
| Persistenz | JSON via path_provider (M1), optional drift/SQLite (M4+) | Einfachster local-first-Pfad |
| Notifications | flutter_local_notifications | Kein Server nötig |
| OCR | google_mlkit_text_recognition | On-device, offline |
| Animations | KYUUBI animations/ + Lottie | Vorhanden, polished |
| Target | iOS + Android (Flutter default) | 99-ct-Preis impliziert Store-Distribution |
| Desktop | Optional M5+ (Flutter desktop) | Gleicher Code, spätere Verbreitung |

---

## 7. Ehrliche Zusammenfassung

**Was gebaut werden muss (neuer Code):**
- ~6 View-Widgets (ForgeListView, Calendar, Board, Grid, BigButton, Launcher)
- 1 ForgeDesignBridge (Bucket → Token, ~80 Zeilen)
- 1 ForgeItemCard (universell, ~200 Zeilen)
- 1 ForgeShell (Navigation/Suche, ~300 Zeilen)
- State Management Layer (~150 Zeilen)
- Capture Flows (manual ~100, OCR ~200, voice ~150 Zeilen)
- Persistent Store Impl (~80 Zeilen)
- 1 winzige archive-Animation (~30 Zeilen)

**Was bereits existiert und nur eingebunden wird:**
- Gesamte Motion Grammar (18 Animationskomponenten)
- Gesamtes Farbsystem + Typografie + Spacing
- ThemeData dark/light
- GooeyButton, BorderBeam, LuminousEnergyLine, ScrollReveal, LiquidValueSlider
- StatusChip, Toasts, Empty States
- Die komplette Engine (evaluate, transitions, profiles, store)

**Was NIE gebaut werden muss:**
- 80 separate Apps
- 80 separate Datenmodelle
- 80 separate Status-Logiken
- Ein Server
- Ein Login-System
- Ein Abo-Modell

Geschätzter Gesamtaufwand neuer Code für M1–M4: ~2000–3000 Zeilen Flutter.
Danach ist M5 (die restlichen 75 "Apps") reine JSON/Dart-Konfiguration.

---

## 8. Der Satz, der alles zusammenfasst

> 80 Apps × 2,49 € = 199 € für den Kunden.
> 1 Engine × N Profile × 99 ct = dasselbe für den Nutzer, ehrlicher für alle.
> Und technisch: ~3000 Zeilen statt ~80 × 5000 = 400.000 Zeilen.
