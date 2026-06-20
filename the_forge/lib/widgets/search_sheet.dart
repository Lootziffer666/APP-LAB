import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_core/forge_core.dart';

import '../state/forge_state.dart';
import '../theme/forge_colors.dart';
import '../theme/forge_design_bridge.dart';

/// Global search sheet — searches across ALL items regardless of profile.
/// Fuzzy match on title and type. Shows results with bucket colors.
class SearchSheet extends ConsumerStatefulWidget {
  const SearchSheet({super.key});

  @override
  ConsumerState<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends ConsumerState<SearchSheet> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allItems = ref.watch(storeProvider);
    final results = _query.isEmpty
        ? <Item>[]
        : allItems.where((item) {
            final q = _query.toLowerCase();
            return item.title.toLowerCase().contains(q) ||
                item.type.toLowerCase().contains(q) ||
                (item.attrs['location'] as String? ?? '')
                    .toLowerCase()
                    .contains(q);
          }).toList()
      ..sort((a, b) {
        final sa = evaluateItem(a);
        final sb = evaluateItem(b);
        return sb.urgency.compareTo(sa.urgency);
      });

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ForgeColors.muted.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Suche über alle Elemente...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _ctrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 8),
            // Results count
            if (_query.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${results.length} Ergebnis${results.length == 1 ? '' : 'se'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ForgeColors.muted.withAlpha(150),
                    ),
                  ),
                ),
              ),
            // Results
            Expanded(
              child: results.isEmpty && _query.isNotEmpty
                  ? Center(
                      child: Text(
                        'Nichts gefunden.',
                        style: TextStyle(color: ForgeColors.muted.withAlpha(150)),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.only(bottom: 40),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        final status = evaluateItem(item);
                        final color = ForgeDesignBridge.instance
                            .bucketColor(status.bucket);

                        return ListTile(
                          leading: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            item.type.replaceAll('_', ' '),
                            style: TextStyle(
                              fontSize: 12,
                              color: ForgeColors.muted.withAlpha(150),
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ForgeDesignBridge.instance
                                  .bucketLabel(status.bucket),
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
