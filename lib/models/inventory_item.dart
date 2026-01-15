import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String? id;
  final String name;
  final String category;
  final double price;
  final bool inStock;
  final double? shopLatitude;
  final double? shopLongitude;
  final String? shopAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InventoryItem({
    this.id,
    required this.name,
    this.category = 'General',
    required this.price,
    required this.inStock,
    this.shopLatitude,
    this.shopLongitude,
    this.shopAddress,
    this.createdAt,
    this.updatedAt,
  });

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    bool? inStock,
    double? shopLatitude,
    double? shopLongitude,
    String? shopAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      shopLatitude: shopLatitude ?? this.shopLatitude,
      shopLongitude: shopLongitude ?? this.shopLongitude,
      shopAddress: shopAddress ?? this.shopAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'inStock': inStock,
      'shopLatitude': shopLatitude,
      'shopLongitude': shopLongitude,
      'shopAddress': shopAddress,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Create from Firestore Document
  factory InventoryItem.fromMap(String id, Map<String, dynamic> map) {
    DateTime? parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return null;
      if (timestamp is Timestamp) return timestamp.toDate();
      if (timestamp is String) return DateTime.tryParse(timestamp);
      return null;
    }

    return InventoryItem(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? 'General',
      price: (map['price'] ?? 0).toDouble(),
      inStock: map['inStock'] ?? false,
      shopLatitude: map['shopLatitude']?.toDouble(),
      shopLongitude: map['shopLongitude']?.toDouble(),
      shopAddress: map['shopAddress'],
      createdAt: parseTimestamp(map['createdAt']),
      updatedAt: parseTimestamp(map['updatedAt']),
    );
  }
}


