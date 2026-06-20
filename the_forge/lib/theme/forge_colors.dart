import 'package:flutter/material.dart';

/// FLUBBER-derived color palette for The Forge.
/// Same tokens as KYUUBI — ensures visual continuity across projects.
abstract final class ForgeColors {
  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color void_ = Color(0xFF0B1020);
  static const Color night = Color(0xFF1E1B4B);
  static const Color surface = Color(0xFF111827);

  // ── Semantic (bucket-mapped) ──────────────────────────────────────────────
  static const Color ok = Color(0xFF22C55E); // lime/green — all good
  static const Color soon = Color(0xFF3EC4D0); // cyan — heads up
  static const Color due = Color(0xFFF97316); // orange — act now
  static const Color critical = Color(0xFFFF5757); // coral — overdue/expired

  // ── Accent ────────────────────────────────────────────────────────────────
  static const Color periwinkle = Color(0xFF8B9FE8);
  static const Color violet = Color(0xFFA855F7);
  static const Color pink = Color(0xFFFF6EB4);
  static const Color lime = Color(0xFF7ED321);
  static const Color yellow = Color(0xFFF5E642);
  static const Color mint = Color(0xFF5DD8A0);

  // ── Neutrals ──────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1C1B2E);
  static const Color ink2 = Color(0x8C1C1B2E);
  static const Color ink3 = Color(0x521C1B2E);
  static const Color muted = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFF1F2937);
  static const Color inputFill = Color(0xFF1F2937);
  static const Color cloud = Color(0xFFF5F5F8);
}
