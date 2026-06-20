// THESE: Es ist EINE App. Jede "Micro-App" ist nur ein Gewichtsvektor.
// Beweis: EINE Engine, EIN Item-Typ, EINE Status-Funktion.
// Der Unterschied zwischen Pflanze, Vertrag, Schraube, Dokument, Routine,
// Medikament ist NUR, welche Signale wie gewichtet werden.

const DAY = 86400000;
const now = new Date("2026-06-19T09:00:00Z").getTime(); // fixe "Jetzt"-Zeit
const clamp = (x, lo = 0, hi = 1) => Math.min(hi, Math.max(lo, x));

// ---------------------------------------------------------------------------
// DIE EINZIGE ENGINE.
// Sie kennt KEINE Themen. Sie kennt nur 4 Signale, jedes 0..1 (= Dringlichkeit).
// ---------------------------------------------------------------------------
function signals(item) {
  const a = item.attrs;
  let time = 0, stock = 0, progress = 0, retention = 0;

  // ZEIT: aus festem Fälligkeitsdatum ODER aus Intervall+letzter-Erledigung
  if (a.dueDate != null) {
    const daysLeft = (a.dueDate - now) / DAY;
    const win = a.warnDays ?? 30;
    time = clamp(1 - daysLeft / win);            // due=jetzt -> 1, weit weg -> 0
    if (daysLeft < 0) time = 1;                   // überfällig -> max
  }
  if (a.intervalDays != null && a.lastDone != null) {
    const elapsed = (now - a.lastDone) / DAY;
    time = Math.max(time, clamp(elapsed / a.intervalDays)); // 1 Intervall vergangen -> 1
  }

  // BESTAND: Menge gegen Nachbestell-Punkt
  if (a.qty != null && a.reorderAt != null) {
    stock = clamp((a.reorderAt - a.qty) / a.reorderAt); // voll -> 0, leer -> 1
  }

  // FORTSCHRITT: erledigte Schritte / Schritte gesamt (nur wenn heute fällig)
  if (a.steps != null) {
    const done = a.steps.filter(s => s.done).length;
    progress = clamp(1 - done / a.steps.length);
  }

  // AUFBEWAHRUNG: wie nah/über dem Verfalls-/Vernichtungsdatum
  if (a.archiveDate != null) {
    const daysLeft = (a.archiveDate - now) / DAY;
    const win = a.warnDays ?? 30;
    retention = clamp(1 - daysLeft / win);
    if (daysLeft < 0) retention = 1;
  }

  return { time, stock, progress, retention };
}

// DIE EINZIGE STATUS-FUNKTION. Gewichteter Mix + Bucketing. Sonst nichts.
function status(item) {
  const s = signals(item);
  const w = item.weights; // <-- HIER lebt der ganze Unterschied der "Apps"
  const wsum = w.time + w.stock + w.progress + w.retention || 1;
  const urgency =
    (s.time * w.time + s.stock * w.stock +
     s.progress * w.progress + s.retention * w.retention) / wsum;

  let bucket = "ok";
  if (urgency >= 0.999) bucket = "critical";
  else if (urgency >= 0.66) bucket = "due";
  else if (urgency >= 0.34) bucket = "soon";

  // welches Signal dominiert -> beweist "Gewichtung verlagert"
  const driver = Object.entries(s)
    .map(([k, v]) => [k, v * (w[k] || 0)])
    .sort((x, y) => y[1] - x[1])[0][0];

  return { urgency: +urgency.toFixed(2), bucket, driver, s };
}

// ---------------------------------------------------------------------------
// THEMATISCH VÖLLIG FREMDE ITEMS. Gleiche Engine. Nur andere Gewichte.
// ---------------------------------------------------------------------------
const W = (o) => ({ time: 0, stock: 0, progress: 0, retention: 0, ...o });

const items = [
  { // "Pflanzen-Gieß-App"  ->  reines Zeit/Intervall-Item
    title: "Monstera gießen",
    weights: W({ time: 1 }),
    attrs: { intervalDays: 7, lastDone: now - 6 * DAY },
    expect: "due",
  },
  { // "Vertrags-Tracker"  ->  reines Datum-Item
    title: "Handytarif kündigen",
    weights: W({ time: 1 }),
    attrs: { dueDate: now + 5 * DAY, warnDays: 30 },
    expect: "due",
  },
  { // "Werkzeug-/Schrauben-Inventar"  ->  reines Bestands-Item
    title: "Spax 4x40 Schrauben",
    weights: W({ stock: 1 }),
    attrs: { qty: 3, reorderAt: 20 },
    expect: "due",
  },
  { // "Rechnungs-Archiv / Aufbewahrungsfrist"  ->  reines Retention-Item
    title: "Stromrechnung 2016 (10J-Frist)",
    weights: W({ retention: 1 }),
    attrs: { archiveDate: now - 2 * DAY, warnDays: 30 }, // Frist abgelaufen
    expect: "critical",
  },
  { // "ADHD-Kids Morning Routine"  ->  reines Fortschritts-Item
    title: "Morgenroutine Kind",
    weights: W({ progress: 1 }),
    attrs: { steps: [
      { t: "anziehen", done: true },
      { t: "Zähne", done: false },
      { t: "Frühstück", done: false },
      { t: "Schuhe", done: false },
    ] },
    expect: "due",
  },
  { // DER ENTSCHEIDENDE FALL:
    // "Medikamenten-Einnahme" + "Vorrats-Tracker" sind angeblich ZWEI Apps.
    // In Wahrheit: EIN Item, zwei Signale, ein Gewichtsvektor.
    title: "Vitamin D (Einnahme + Vorrat)",
    weights: W({ time: 0.6, stock: 0.4 }),
    attrs: {
      intervalDays: 1, lastDone: now - 1 * DAY, // heute fällig
      qty: 8, reorderAt: 10,                     // fast leer
    },
    expect: "due",
  },
  { // "NEUE App" ohne neuen Code: nur Daten. Auto-Service.
    title: "TÜV / HU faellig",
    weights: W({ time: 1 }),
    attrs: { dueDate: now + 40 * DAY, warnDays: 30 }, // noch weit weg
    expect: "ok",
  },
];

// ---------------------------------------------------------------------------
// AUSFÜHREN + VERIFIZIEREN (nicht nur "läuft", sondern "stimmt").
// ---------------------------------------------------------------------------
let fails = 0;
console.log("ITEM".padEnd(34), "DRIVER".padEnd(10), "URG".padEnd(6), "STATUS".padEnd(9), "OK?");
console.log("-".repeat(72));
for (const it of items) {
  const r = status(it);
  const ok = r.bucket === it.expect;
  if (!ok) fails++;
  console.log(
    it.title.padEnd(34),
    r.driver.padEnd(10),
    String(r.urgency).padEnd(6),
    r.bucket.padEnd(9),
    ok ? "PASS" : `FAIL (erwartet ${it.expect})`
  );
}
console.log("-".repeat(72));
console.log(`Engine-Codezeilen pro "App": 0.  Neue App = neuer Gewichtsvektor.`);
console.log(fails === 0
  ? "ALLE BESTANDEN: 7 fremde Themen, 1 Engine, 1 Statusfunktion."
  : `${fails} FEHLGESCHLAGEN — These widerlegt.`);
process.exit(fails === 0 ? 0 : 1);
