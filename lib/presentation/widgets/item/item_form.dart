import 'package:flutter/material.dart';

/// Form widget for creating or editing items
class ItemForm extends StatefulWidget {
  const ItemForm({
    super.key,
    this.onSubmit,
    this.initialItemName = '',
    this.initialCategory = '',
    this.initialLocation = '',
    this.initialDescription = '',
    this.initialReportType = 'Lost',
  });

  final Function(Map<String, String> data)? onSubmit;
  final String initialItemName;
  final String initialCategory;
  final String initialLocation;
  final String initialDescription;
  final String initialReportType;

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  late final TextEditingController _itemNameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late String _reportType;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.initialItemName);
    _categoryController = TextEditingController(text: widget.initialCategory);
    _locationController = TextEditingController(text: widget.initialLocation);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _reportType = widget.initialReportType;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call({
        'itemName': _itemNameController.text,
        'category': _categoryController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'reportType': _reportType,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: _reportType,
            decoration: const InputDecoration(
              labelText: 'Report Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Lost', child: Text('Lost')),
              DropdownMenuItem(value: 'Found', child: Text('Found')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _reportType = value;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter item name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter category';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Last Seen / Found Location',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter location';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
