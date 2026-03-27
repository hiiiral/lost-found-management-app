import 'package:flutter/material.dart';
import 'status_badge.dart';

/// Tile widget to display item information in a list
class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.itemName,
    required this.category,
    required this.location,
    required this.status,
    this.onTap,
    this.trailing,
  });

  final String itemName;
  final String category;
  final String location;
  final String status;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(itemName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text('$category • $location'),
          const SizedBox(height: 4),
          StatusBadge(status: status),
        ],
      ),
      onTap: onTap,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
