import 'package:flutter/material.dart';

import '../../../data/models/item_model.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../claims/claim_request_screen.dart';
import 'report_item_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  final ItemModel item;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final ItemRepository _itemRepository = ItemRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  late ItemModel _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Color _statusColor(BuildContext context) {
    switch (_item.status.toLowerCase()) {
      case 'claimed':
      case 'resolved':
        return Colors.green;
      case 'in review':
      case 'pending':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Future<void> _updateLifecycle(String status) async {
    final updated = await _itemRepository.updateItemStatus(_item.id, status);
    if (!mounted || updated == null) {
      return;
    }

    await _notificationRepository.add(
      title: 'Item Status Updated',
      message: '${updated.name} moved to $status.',
    );

    setState(() {
      _item = updated;
    });
  }

  Future<void> _deleteItem() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('This will remove this item report permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    final success = await _itemRepository.deleteItem(_item.id);
    if (!mounted || !success) {
      return;
    }

    await _notificationRepository.add(
      title: 'Item Deleted',
      message: '${_item.name} report was removed.',
    );

    if (!mounted) {
      return;
    }
    Navigator.pop(context, true);
  }

  Future<void> _editItem() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => ReportItemScreen(initialItem: _item),
      ),
    );
    if (changed != true || !mounted) {
      return;
    }
    final refreshed = await _itemRepository.getItemById(_item.id);
    if (refreshed == null || !mounted) {
      return;
    }
    setState(() {
      _item = refreshed;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _item.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text('Category: ${_item.category}')),
                        Chip(label: Text('Location: ${_item.location}')),
                        Chip(
                            label:
                                Text('Date: ${_formatDate(_item.reportedAt)}')),
                        Chip(label: Text('Type: ${_item.reportType}')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        'Status: ${_item.status}',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(_item.description),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: _editItem,
                          child: const Text('Edit'),
                        ),
                        OutlinedButton(
                          onPressed: _deleteItem,
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lifecycle',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _StatusButton(
                          label: 'Reported',
                          currentStatus: _item.status,
                          onSelected: _updateLifecycle,
                        ),
                        _StatusButton(
                          label: 'In Review',
                          currentStatus: _item.status,
                          onSelected: _updateLifecycle,
                        ),
                        _StatusButton(
                          label: 'Claimed',
                          currentStatus: _item.status,
                          onSelected: _updateLifecycle,
                        ),
                        _StatusButton(
                          label: 'Resolved',
                          currentStatus: _item.status,
                          onSelected: _updateLifecycle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (context) => ClaimRequestScreen(
                      itemId: _item.id,
                      itemName: _item.name,
                    ),
                  ),
                );
              },
              child: const Text('Request Claim'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.label,
    required this.currentStatus,
    required this.onSelected,
  });

  final String label;
  final String currentStatus;
  final Future<void> Function(String status) onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = label.toLowerCase() == currentStatus.toLowerCase();

    return ChoiceChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) {
        if (!selected) {
          onSelected(label);
        }
      },
    );
  }
}
