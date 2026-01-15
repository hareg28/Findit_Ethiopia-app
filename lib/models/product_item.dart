import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItem {
  final String? id;
  final String name;
  final String category;
  final double price;
  final double distanceKm;
  final String shopName;
  final String shopId;
  final bool inStock;
  final double? shopLatitude;
  final double? shopLongitude;
  final String? shopAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductItem({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.distanceKm,
    required this.shopName,
    required this.shopId,
    required this.inStock,
    this.shopLatitude,
    this.shopLongitude,
    this.shopAddress,
    this.createdAt,
    this.updatedAt,
  });

  ProductItem copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    double? distanceKm,
    String? shopName,
    String? shopId,
    bool? inStock,
    double? shopLatitude,
    double? shopLongitude,
    String? shopAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      distanceKm: distanceKm ?? this.distanceKm,
      shopName: shopName ?? this.shopName,
      shopId: shopId ?? this.shopId,
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
      'shopName': shopName,
      'shopId': shopId,
      'inStock': inStock,
      'shopLatitude': shopLatitude,
      'shopLongitude': shopLongitude,
      'shopAddress': shopAddress,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Create from Firestore Document
  factory ProductItem.fromMap(String id, Map<String, dynamic> map, {double distanceKm = 0.0}) {
    DateTime? parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return null;
      if (timestamp is Timestamp) return timestamp.toDate();
      if (timestamp is String) return DateTime.tryParse(timestamp);
      return null;
    }

    return ProductItem(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      distanceKm: distanceKm,
      shopName: map['shopName'] ?? '',
      shopId: map['shopId'] ?? '',
      inStock: map['inStock'] ?? false,
      shopLatitude: map['shopLatitude']?.toDouble(),
      shopLongitude: map['shopLongitude']?.toDouble(),
      shopAddress: map['shopAddress'],
      createdAt: parseTimestamp(map['createdAt']),
      updatedAt: parseTimestamp(map['updatedAt']),
    );
  }
}


