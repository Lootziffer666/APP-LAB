import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/forge_theme.dart';
import 'shell/forge_shell.dart';

class ForgeApp extends ConsumerWidget {
  const ForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'The Forge',
      debugShowCheckedModeBanner: false,
      theme: ForgeTheme.light,
      darkTheme: ForgeTheme.dark,
      themeMode: ThemeMode.dark,
      home: const ForgeShell(),
    );
  }
}
