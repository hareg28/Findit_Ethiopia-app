class InventoryItem {
  final String name;
  final double price;
  final bool inStock;
  final double? shopLatitude;
  final double? shopLongitude;
  final String? shopAddress;

  InventoryItem({
    required this.name,
    required this.price,
    required this.inStock,
    this.shopLatitude,
    this.shopLongitude,
    this.shopAddress,
  });

  InventoryItem copyWith({
    String? name,
    double? price,
    bool? inStock,
    double? shopLatitude,
    double? shopLongitude,
    String? shopAddress,
  }) {
    return InventoryItem(
      name: name ?? this.name,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      shopLatitude: shopLatitude ?? this.shopLatitude,
      shopLongitude: shopLongitude ?? this.shopLongitude,
      shopAddress: shopAddress ?? this.shopAddress,
    );
  }
}


