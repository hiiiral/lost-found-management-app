import 'package:flutter/material.dart';
import 'package:lost_found_management_app/admin/widgets/admin_bottom_nav.dart';

class ManageItemsScreen extends StatefulWidget {
  const ManageItemsScreen({super.key});

  @override
  State<ManageItemsScreen> createState() => _ManageItemsScreenState();
}

class _ManageItemsScreenState extends State<ManageItemsScreen> {
  final List<_ItemEntry> _items = [
    const _ItemEntry(
      itemName: 'Black Laptop Bag',
      category: 'Accessories',
      place: 'Engineering Block',
      date: 'Today, 9:30 AM',
      status: 'Matched',
      statusColor: Color(0xFF2A9D8F),
    ),
    const _ItemEntry(
      itemName: 'Student ID Card',
      category: 'Identity',
      place: 'Library Counter',
      date: 'Today, 8:10 AM',
      status: 'New',
      statusColor: Color(0xFFD62828),
    ),
    const _ItemEntry(
      itemName: 'Blue Water Bottle',
      category: 'Personal Item',
      place: 'Sports Complex',
      date: 'Yesterday, 5:20 PM',
      status: 'Stored',
      statusColor: Color(0xFFF4A261),
    ),
    const _ItemEntry(
      itemName: 'Mobile Phone',
      category: 'Electronics',
      place: 'Admin Office',
      date: 'Yesterday, 1:00 PM',
      status: 'Claimed',
      statusColor: Color(0xFF0F3D56),
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  int get _totalItems => _items.length;

  int get _unclaimedItems => _items
      .where((item) => item.status == 'New' || item.status == 'Stored')
      .length;

  int get _returnedItems => _items
      .where((item) => item.status == 'Claimed' || item.status == 'Matched')
      .length;

  int get _highPriorityItems =>
      _items.where((item) => item.status == 'New').length;

  List<_ItemEntry> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();

    return _items.where((item) {
      final matchesSearch =
          query.isEmpty ||
          item.itemName.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.place.toLowerCase().contains(query);
      final matchesStatus =
          _selectedStatus == 'All' || item.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddItemForm() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final placeController = TextEditingController();
    String status = 'New';

    final created = await showDialog<_ItemEntry?>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Item'),
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          hintText: 'Enter item name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Item name is required';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          hintText: 'Enter category',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Category is required';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: placeController,
                        decoration: const InputDecoration(
                          labelText: 'Place',
                          hintText: 'Enter location',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Place is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: status,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: const [
                          DropdownMenuItem(value: 'New', child: Text('New')),
                          DropdownMenuItem(
                            value: 'Stored',
                            child: Text('Stored'),
                          ),
                          DropdownMenuItem(
                            value: 'Matched',
                            child: Text('Matched'),
                          ),
                          DropdownMenuItem(
                            value: 'Claimed',
                            child: Text('Claimed'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setDialogState(() {
                            status = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, null);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      return;
                    }

                    final newItem = _ItemEntry(
                      itemName: nameController.text.trim(),
                      category: categoryController.text.trim(),
                      place: placeController.text.trim(),
                      date: 'Just now',
                      status: status,
                      statusColor: _statusColor(status),
                    );

                    Navigator.pop(dialogContext, newItem);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F3D56),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    categoryController.dispose();
    placeController.dispose();

    if (!mounted) {
      return;
    }

    if (created == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add item canceled')));
      return;
    }

    setState(() {
      _items.insert(0, created);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${created.itemName} added successfully')),
    );
  }

  static Color _statusColor(String status) {
    switch (status) {
      case 'Matched':
        return const Color(0xFF2A9D8F);
      case 'Stored':
        return const Color(0xFFF4A261);
      case 'Claimed':
        return const Color(0xFF0F3D56);
      case 'New':
      default:
        return const Color(0xFFD62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredItems = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        title: const Text('Manage Items'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3D56), Color(0xFF1D6F8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Records',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monitor lost and found item entries, check their category, and update recovery status across campus.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ItemSummaryCard(
                    title: 'Total Items',
                    value: _totalItems.toString(),
                    color: const Color(0xFF0F3D56),
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ItemSummaryCard(
                    title: 'Unclaimed',
                    value: _unclaimedItems.toString(),
                    color: const Color(0xFFD62828),
                    icon: Icons.hourglass_bottom_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ItemSummaryCard(
                    title: 'Returned',
                    value: _returnedItems.toString(),
                    color: const Color(0xFF2A9D8F),
                    icon: Icons.assignment_turned_in_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ItemSummaryCard(
                    title: 'High Priority',
                    value: _highPriorityItems.toString(),
                    color: const Color(0xFFF4A261),
                    icon: Icons.priority_high_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search by item, category, or place',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                      filled: true,
                      fillColor: const Color(0xFFF4F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Filter by status',
                      filled: true,
                      fillColor: const Color(0xFFF4F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All Statuses'),
                      ),
                      DropdownMenuItem(value: 'New', child: Text('New')),
                      DropdownMenuItem(value: 'Stored', child: Text('Stored')),
                      DropdownMenuItem(
                        value: 'Matched',
                        child: Text('Matched'),
                      ),
                      DropdownMenuItem(
                        value: 'Claimed',
                        child: Text('Claimed'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Item Entries',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF102A43),
              ),
            ),
            const SizedBox(height: 12),
            if (filteredItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'No matching items found.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7C93),
                  ),
                ),
              )
            else
              ...filteredItems.map(
                (item) => _ItemTile(
                  itemName: item.itemName,
                  category: item.category,
                  place: item.place,
                  date: item.date,
                  status: item.status,
                  statusColor: item.statusColor,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemForm,
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Add Item'),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
    );
  }
}

class _ItemSummaryCard extends StatefulWidget {
  const _ItemSummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  State<_ItemSummaryCard> createState() => _ItemSummaryCardState();
}

class _ItemSummaryCardState extends State<_ItemSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: widget.color.withOpacity(0.12),
            child: Icon(widget.icon, color: widget.color),
          ),
          const SizedBox(height: 14),
          Text(
            widget.value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF486581),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatefulWidget {
  const _ItemTile({
    required this.itemName,
    required this.category,
    required this.place,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  final String itemName;
  final String category;
  final String place;
  final String date;
  final String status;
  final Color statusColor;

  @override
  State<_ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<_ItemTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: widget.statusColor.withOpacity(0.12),
            child: Icon(Icons.inventory_2_rounded, color: widget.statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.itemName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF102A43),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.category} | ${widget.place}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7C93),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF829AB1),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: widget.statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.status,
              style: TextStyle(
                color: widget.statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemEntry {
  const _ItemEntry({
    required this.itemName,
    required this.category,
    required this.place,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  final String itemName;
  final String category;
  final String place;
  final String date;
  final String status;
  final Color statusColor;
}
