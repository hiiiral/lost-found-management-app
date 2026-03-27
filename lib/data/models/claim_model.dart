/// Claim data model for item claims
class ClaimModel {
  final String id;
  final String itemId;
  final String claimedBy;
  final String proofOfOwnership;
  final String notes;
  final String status; // 'Pending', 'Approved', 'Rejected'
  final DateTime claimedAt;

  ClaimModel({
    required this.id,
    required this.itemId,
    required this.claimedBy,
    required this.proofOfOwnership,
    required this.notes,
    required this.status,
    required this.claimedAt,
  });

  /// Convert ClaimModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'itemId': itemId,
        'claimedBy': claimedBy,
        'proofOfOwnership': proofOfOwnership,
        'notes': notes,
        'status': status,
        'claimedAt': claimedAt.toIso8601String(),
      };

  /// Create ClaimModel from JSON
  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      claimedBy: json['claimedBy'] as String,
      proofOfOwnership: json['proofOfOwnership'] as String,
      notes: json['notes'] as String,
      status: json['status'] as String,
      claimedAt: DateTime.parse(json['claimedAt'] as String),
    );
  }

  /// Create a copy with updated fields
  ClaimModel copyWith({
    String? id,
    String? itemId,
    String? claimedBy,
    String? proofOfOwnership,
    String? notes,
    String? status,
    DateTime? claimedAt,
  }) {
    return ClaimModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      claimedBy: claimedBy ?? this.claimedBy,
      proofOfOwnership: proofOfOwnership ?? this.proofOfOwnership,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      claimedAt: claimedAt ?? this.claimedAt,
    );
  }
}
