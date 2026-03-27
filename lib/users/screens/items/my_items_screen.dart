import 'package:flutter/material.dart';
import '../../../data/models/item_model.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../presentation/screens/items/item_detail_screen.dart';
import '../../../presentation/screens/items/report_item_screen.dart';
import '../../../presentation/widgets/common/item_card.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({super.key});

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  final ItemRepository _itemRepository = ItemRepository();
  List<ItemModel> _myItems = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _itemRepository.getItemsByReporter('user1');
    if (!mounted) {
      return;
    }
    setState(() {
      _myItems = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute<bool>(
                  builder: (context) => const ReportItemScreen(),
                ),
              );
              if (result == true) {
                setState(() => _loading = true);
                await _load();
              }
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _myItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No items reported yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute<bool>(
                              builder: (context) => const ReportItemScreen(),
                            ),
                          );
                          if (result == true) {
                            setState(() => _loading = true);
                            await _load();
                          }
                        },
                        child: const Text('Report an Item'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._myItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ItemCard(
                            itemName: item.name,
                            category: item.category,
                            location: item.location,
                            status: item.status,
                            onTap: () async {
                              final changed = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute<bool>(
                                  builder: (context) =>
                                      ItemDetailScreen(item: item),
                                ),
                              );
                              if (changed == true) {
                                setState(() => _loading = true);
                                await _load();
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}
