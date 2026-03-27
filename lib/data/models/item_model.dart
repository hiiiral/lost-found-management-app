/// Item data model for lost/found items
class ItemModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String description;
  final String reportType; // 'Lost' or 'Found'
  final String status;
  final String reportedBy;
  final DateTime reportedAt;

  ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.reportType,
    required this.status,
    required this.reportedBy,
    required this.reportedAt,
  });

  /// Convert ItemModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'location': location,
        'description': description,
        'reportType': reportType,
        'status': status,
        'reportedBy': reportedBy,
        'reportedAt': reportedAt.toIso8601String(),
      };

  /// Create ItemModel from JSON
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      reportType: json['reportType'] as String,
      status: json['status'] as String,
      reportedBy: json['reportedBy'] as String,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
    );
  }

  /// Create a copy with updated fields
  ItemModel copyWith({
    String? id,
    String? name,
    String? category,
    String? location,
    String? description,
    String? reportType,
    String? status,
    String? reportedBy,
    DateTime? reportedAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      reportType: reportType ?? this.reportType,
      status: status ?? this.status,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedAt: reportedAt ?? this.reportedAt,
    );
  }
}
