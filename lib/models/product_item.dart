class ProductItem {
  final String name;
  final String category;
  final double price;
  final double distanceKm;
  final String shopName;
  final bool inStock;
  final double? shopLatitude;
  final double? shopLongitude;
  final String? shopAddress;

  ProductItem({
    required this.name,
    required this.category,
    required this.price,
    required this.distanceKm,
    required this.shopName,
    required this.inStock,
    this.shopLatitude,
    this.shopLongitude,
    this.shopAddress,
  });

  ProductItem copyWith({
    String? name,
    String? category,
    double? price,
    double? distanceKm,
    String? shopName,
    bool? inStock,
    double? shopLatitude,
    double? shopLongitude,
    String? shopAddress,
  }) {
    return ProductItem(
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      distanceKm: distanceKm ?? this.distanceKm,
      shopName: shopName ?? this.shopName,
      inStock: inStock ?? this.inStock,
      shopLatitude: shopLatitude ?? this.shopLatitude,
      shopLongitude: shopLongitude ?? this.shopLongitude,
      shopAddress: shopAddress ?? this.shopAddress,
    );
  }
}


