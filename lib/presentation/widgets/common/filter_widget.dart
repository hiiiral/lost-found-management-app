import 'package:flutter/material.dart';

/// Filter widget to filter items by category and status
class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
    this.categories = const ['All', 'Bag', 'Electronics', 'Keys', 'Other'],
    this.statuses = const [
      'All',
      'Reported',
      'In Review',
      'Claimed',
      'Resolved'
    ],
    this.onFilterChanged,
  });

  final List<String> categories;
  final List<String> statuses;
  final Function(String selectedCategory, String selectedStatus)?
      onFilterChanged;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late String _selectedCategory;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
    _selectedStatus = widget.statuses.first;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategory,
              hint: const Text('Category'),
              items: widget.categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                  widget.onFilterChanged
                      ?.call(_selectedCategory, _selectedStatus);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedStatus,
              hint: const Text('Status'),
              items: widget.statuses
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                  widget.onFilterChanged
                      ?.call(_selectedCategory, _selectedStatus);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
