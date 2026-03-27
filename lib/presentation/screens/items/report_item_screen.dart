import 'package:flutter/material.dart';

import '../../../data/models/item_model.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../widgets/item/item_form.dart';

class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({
    super.key,
    this.initialItem,
  });

  final ItemModel? initialItem;

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final ItemRepository _itemRepository = ItemRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  Future<void> _submitForm(Map<String, String> formData) async {
    final base = widget.initialItem;

    final item = ItemModel(
      id: base?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: (formData['itemName'] ?? '').trim(),
      category: (formData['category'] ?? '').trim(),
      location: (formData['location'] ?? '').trim(),
      description: (formData['description'] ?? '').trim(),
      reportType: (formData['reportType'] ?? 'Lost').trim(),
      status: base?.status ?? 'Reported',
      reportedBy: base?.reportedBy ?? 'user1',
      reportedAt: base?.reportedAt ?? DateTime.now(),
    );

    final saved = base == null
        ? await _itemRepository.createItem(item)
        : await _itemRepository.updateItem(item);

    if (!mounted || saved == null) {
      return;
    }

    await _notificationRepository.add(
      title: base == null ? 'Item Reported' : 'Item Updated',
      message:
          '${saved.name} has been ${base == null ? 'reported' : 'updated'}.',
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          base == null
              ? 'Report submitted successfully.'
              : 'Item updated successfully.',
        ),
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialItem == null ? 'Report Item' : 'Edit Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ItemForm(
          onSubmit: _submitForm,
          initialItemName: widget.initialItem?.name ?? '',
          initialCategory: widget.initialItem?.category ?? '',
          initialLocation: widget.initialItem?.location ?? '',
          initialDescription: widget.initialItem?.description ?? '',
          initialReportType: widget.initialItem?.reportType ?? 'Lost',
        ),
      ),
    );
  }
}
