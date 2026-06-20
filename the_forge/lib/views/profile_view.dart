import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../state/forge_state.dart';
import '../widgets/forge_item_card.dart';
import '../widgets/add_item_sheet.dart';
import '../animations/scroll_reveal.dart';
import 'board_view.dart';
import 'grid_view.dart';
import 'big_button_view.dart';

/// Renders a single profile's view.
/// Dispatches to the correct view widget based on [Profile.view].
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allItems = ref.watch(storeProvider);
    final items = profile.select(allItems).toList()
      ..sort((a, b) {
        final sa = evaluateItem(a);
        final sb = evaluateItem(b);
        return sb.urgency.compareTo(sa.urgency);
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {}, // M4: global search
          ),
        ],
      ),
      body: _buildView(context, items),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildView(BuildContext context, List<Item> items) {
    if (items.isEmpty) return _EmptyState(profile: profile);

    return switch (profile.view) {
      ViewId.list => _ListView(items: items, profile: profile),
      ViewId.board => _BoardListView(items: items),
      ViewId.grid => InventoryGridView(items: items, profile: profile),
      ViewId.bigButton => BigButtonView(items: items, profile: profile),
      _ => _ListView(items: items, profile: profile),
    };
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddItemSheet(profile: profile),
    );
  }
}

/// Default list view — sorted by urgency, staggered reveal, swipe-to-complete.
class _ListView extends StatelessWidget {
  const _ListView({required this.items, required this.profile});

  final List<Item> items;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ScrollReveal(
          delay: Duration(milliseconds: index * 50),
          child: ForgeItemCard(item: items[index], profile: profile),
        );
      },
    );
  }
}

/// Board view wraps each routine item in a BoardView card.
class _BoardListView extends StatelessWidget {
  const _BoardListView({required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ScrollReveal(
          delay: Duration(milliseconds: index * 60),
          child: BoardView(item: items[index]),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'Noch nichts hier.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tippe +, um dein erstes Element hinzuzufügen.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
