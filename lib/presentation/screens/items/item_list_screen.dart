import 'package:flutter/material.dart';
import '../../../data/models/item_model.dart';
import '../../../data/repositories/item_repository.dart';
import '../../widgets/common/item_card.dart';
import '../../widgets/common/filter_widget.dart';
import 'item_detail_screen.dart';
import 'report_item_screen.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ItemRepository _itemRepository = ItemRepository();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedStatus = 'All';
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _loading = true;
  List<ItemModel> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final items = await _itemRepository.searchItems(
      query: _searchController.text,
      category: _selectedCategory,
      location: _locationController.text,
      fromDate: _fromDate,
      toDate: _toDate,
      status: _selectedStatus,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _pickDate(bool isFromDate) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      if (isFromDate) {
        _fromDate = selected;
      } else {
        _toDate = selected;
      }
      _loading = true;
    });
    await _loadItems();
  }

  String _dateLabel(DateTime? date) {
    if (date == null) {
      return 'Any';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _clearFilters() async {
    setState(() {
      _selectedCategory = 'All';
      _selectedStatus = 'All';
      _fromDate = null;
      _toDate = null;
      _searchController.clear();
      _locationController.clear();
      _loading = true;
    });
    await _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            onPressed: () async {
              final created = await Navigator.push<bool>(
                context,
                MaterialPageRoute<bool>(
                  builder: (context) => const ReportItemScreen(),
                ),
              );
              if (created == true) {
                setState(() => _loading = true);
                await _loadItems();
              }
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadItems,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by item name or description',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  onPressed: () async {
                    setState(() => _loading = true);
                    await _loadItems();
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) async {
                setState(() => _loading = true);
                await _loadItems();
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location filter',
                hintText: 'Library, Dormitory, Cafeteria...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) async {
                setState(() => _loading = true);
                await _loadItems();
              },
            ),
            const SizedBox(height: 12),
            FilterWidget(
              categories: const [
                'All',
                'Bag',
                'Electronics',
                'Keys',
                'Accessories',
                'Other'
              ],
              statuses: const [
                'All',
                'Reported',
                'In Review',
                'Claimed',
                'Resolved'
              ],
              onFilterChanged: (category, status) async {
                setState(() {
                  _selectedCategory = category;
                  _selectedStatus = status;
                  _loading = true;
                });
                await _loadItems();
              },
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date range',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _pickDate(true),
                            child: Text('From: ${_dateLabel(_fromDate)}'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _pickDate(false),
                            child: Text('To: ${_dateLabel(_toDate)}'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Clear filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _loading ? 'Loading...' : 'Found ${_items.length} item(s)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_items.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No items matched your filters.'),
                ),
              )
            else
              ..._items.map((item) {
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
                          builder: (context) => ItemDetailScreen(item: item),
                        ),
                      );
                      if (changed == true) {
                        setState(() => _loading = true);
                        await _loadItems();
                      }
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
