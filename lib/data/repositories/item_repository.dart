import '../models/item_model.dart';

/// Item repository for managing item data operations
class ItemRepository {
  // Singleton instance
  static final ItemRepository _instance = ItemRepository._internal();

  factory ItemRepository() {
    return _instance;
  }

  ItemRepository._internal();

  // Mock item storage
  final Map<String, ItemModel> _items = {
    '1': ItemModel(
      id: '1',
      name: 'Black Backpack',
      category: 'Bag',
      location: 'Library - Block A',
      description: 'Black backpack with laptop compartment',
      reportType: 'Lost',
      status: 'Reported',
      reportedBy: 'user1',
      reportedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  };

  /// Get all items
  Future<List<ItemModel>> getAllItems() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _items.values.toList();
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }

  /// Get items reported by a specific user
  Future<List<ItemModel>> getItemsByReporter(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      return _items.values.where((item) => item.reportedBy == userId).toList();
    } catch (e) {
      print('Error fetching items by reporter: $e');
      return [];
    }
  }

  /// Get item by ID
  Future<ItemModel?> getItemById(String itemId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _items[itemId];
    } catch (e) {
      print('Error fetching item: $e');
      return null;
    }
  }

  /// Create new item
  Future<ItemModel?> createItem(ItemModel item) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      _items[item.id] = item;
      return item;
    } catch (e) {
      print('Error creating item: $e');
      return null;
    }
  }

  /// Update item
  Future<ItemModel?> updateItem(ItemModel item) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      _items[item.id] = item;
      return item;
    } catch (e) {
      print('Error updating item: $e');
      return null;
    }
  }

  /// Delete item
  Future<bool> deleteItem(String itemId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _items.remove(itemId);
      return true;
    } catch (e) {
      print('Error deleting item: $e');
      return false;
    }
  }

  /// Update the status of an item within lifecycle stages
  Future<ItemModel?> updateItemStatus(String itemId, String status) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final existing = _items[itemId];
      if (existing == null) {
        return null;
      }
      final updated = existing.copyWith(status: status);
      _items[itemId] = updated;
      return updated;
    } catch (e) {
      print('Error updating item status: $e');
      return null;
    }
  }

  /// Get items by category
  Future<List<ItemModel>> getItemsByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _items.values.where((item) => item.category == category).toList();
    } catch (e) {
      print('Error fetching items by category: $e');
      return [];
    }
  }

  /// Get items by status
  Future<List<ItemModel>> getItemsByStatus(String status) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _items.values.where((item) => item.status == status).toList();
    } catch (e) {
      print('Error fetching items by status: $e');
      return [];
    }
  }

  /// Search and filter items by optional query, category, location, date and status
  Future<List<ItemModel>> searchItems({
    String query = '',
    String? category,
    String? location,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      final normalizedQuery = query.trim().toLowerCase();
      final normalizedCategory = category?.trim().toLowerCase();
      final normalizedLocation = location?.trim().toLowerCase();
      final normalizedStatus = status?.trim().toLowerCase();

      return _items.values.where((item) {
        final matchesQuery = normalizedQuery.isEmpty ||
            item.name.toLowerCase().contains(normalizedQuery) ||
            item.description.toLowerCase().contains(normalizedQuery);

        final matchesCategory = normalizedCategory == null ||
            normalizedCategory.isEmpty ||
            normalizedCategory == 'all' ||
            item.category.toLowerCase() == normalizedCategory;

        final matchesLocation = normalizedLocation == null ||
            normalizedLocation.isEmpty ||
            item.location.toLowerCase().contains(normalizedLocation);

        final matchesStatus = normalizedStatus == null ||
            normalizedStatus.isEmpty ||
            normalizedStatus == 'all' ||
            item.status.toLowerCase() == normalizedStatus;

        final matchesFromDate = fromDate == null ||
            !item.reportedAt.isBefore(
              DateTime(fromDate.year, fromDate.month, fromDate.day),
            );

        final matchesToDate = toDate == null ||
            !item.reportedAt.isAfter(
              DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59),
            );

        return matchesQuery &&
            matchesCategory &&
            matchesLocation &&
            matchesStatus &&
            matchesFromDate &&
            matchesToDate;
      }).toList()
        ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    } catch (e) {
      print('Error searching items: $e');
      return [];
    }
  }
}
