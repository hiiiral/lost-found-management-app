import 'package:flutter/material.dart';

/// Form widget for submitting item claims
class ClaimForm extends StatefulWidget {
  const ClaimForm({
    super.key,
    this.onSubmit,
    this.itemName = '',
  });

  final Function(Map<String, String> data)? onSubmit;
  final String itemName;

  @override
  State<ClaimForm> createState() => _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  late final TextEditingController _itemNameController;
  late final TextEditingController _proofController;
  late final TextEditingController _notesController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.itemName);
    _proofController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _proofController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call({
        'itemName': _itemNameController.text,
        'proof': _proofController.text,
        'notes': _notesController.text,
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
            controller: _proofController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Proof of Ownership',
              hintText:
                  'Describe unique features or identifying marks of the item',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please provide proof of ownership';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Additional Notes (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit Claim'),
          ),
        ],
      ),
    );
  }
}
