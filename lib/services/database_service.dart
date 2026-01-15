import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_item.dart';
import '../models/inventory_item.dart';
import '../services/location_service.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  String get _productsCollection => 'products';
  String get _shopsCollection => 'shops';
  String get _inventoryCollection => 'inventory';
  String get _categoriesCollection => 'categories';

  // ============ SHOP OPERATIONS ============

  Future<String?> createOrUpdateShop({
    required String userId,
    required String shopName,
    required String address,
    required double latitude,
    required double longitude,
    bool isOpen = true,
  }) async {
    try {
      final shopData = {
        'userId': userId,
        'shopName': shopName,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'isOpen': isOpen,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Check if shop exists for this user
      final shopQuery = await _firestore
          .collection(_shopsCollection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      String shopId;
      if (shopQuery.docs.isEmpty) {
        // Create new shop
        shopData['createdAt'] = FieldValue.serverTimestamp();
        final docRef = await _firestore.collection(_shopsCollection).add(shopData);
        shopId = docRef.id;
      } else {
        // Update existing shop
        shopId = shopQuery.docs.first.id;
        await _firestore.collection(_shopsCollection).doc(shopId).update(shopData);
      }

      return shopId;
    } catch (e) {
      throw Exception('Error creating/updating shop: $e');
    }
  }

  Future<Map<String, dynamic>?> getShopByUserId(String userId) async {
    try {
      final query = await _firestore
          .collection(_shopsCollection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    } catch (e) {
      throw Exception('Error getting shop: $e');
    }
  }

  Future<void> updateShopStatus(String shopId, bool isOpen) async {
    try {
      await _firestore.collection(_shopsCollection).doc(shopId).update({
        'isOpen': isOpen,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating shop status: $e');
    }
  }

  // ============ PRODUCT OPERATIONS ============

  Stream<List<ProductItem>> getProductsStream({
    String? category,
    String? searchQuery,
    double? userLatitude,
    double? userLongitude,
  }) {
    Query query = _firestore.collection(_productsCollection);

    // Filter by inStock and category if provided
    if (category != null && category != 'All') {
      query = query
          .where('inStock', isEqualTo: true)
          .where('category', isEqualTo: category);
    } else {
      query = query.where('inStock', isEqualTo: true);
    }

    // Note: orderBy requires an index in Firestore when used with where
    // For now, we'll sort in memory if needed
    // query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Calculate distance if user location is provided
        double distanceKm = 0.0;
        if (userLatitude != null && 
            userLongitude != null && 
            data['shopLatitude'] != null && 
            data['shopLongitude'] != null) {
          distanceKm = LocationService.calculateDistance(
            userLatitude,
            userLongitude,
            (data['shopLatitude'] as num).toDouble(),
            (data['shopLongitude'] as num).toDouble(),
          );
        }

        final product = ProductItem.fromMap(doc.id, data, distanceKm: distanceKm);

        // Filter by search query if provided
        if (searchQuery != null && searchQuery.isNotEmpty) {
          final queryLower = searchQuery.toLowerCase();
          if (!product.name.toLowerCase().contains(queryLower) &&
              !product.shopName.toLowerCase().contains(queryLower)) {
            return null;
          }
        }

        return product;
      }).where((product) => product != null).cast<ProductItem>().toList()
        ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    });
  }

  Future<List<ProductItem>> getProducts({
    String? category,
    String? searchQuery,
    double? userLatitude,
    double? userLongitude,
  }) async {
    try {
      Query query = _firestore
          .collection(_productsCollection)
          .where('inStock', isEqualTo: true);

      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      // Note: orderBy requires an index in Firestore when used with where
      // We'll sort by distance in memory instead
      // query = query.orderBy('createdAt', descending: true);

      final snapshot = await query.get();
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        double distanceKm = 0.0;
        if (userLatitude != null && 
            userLongitude != null && 
            data['shopLatitude'] != null && 
            data['shopLongitude'] != null) {
          distanceKm = LocationService.calculateDistance(
            userLatitude,
            userLongitude,
            (data['shopLatitude'] as num).toDouble(),
            (data['shopLongitude'] as num).toDouble(),
          );
        }

        return ProductItem.fromMap(doc.id, data, distanceKm: distanceKm);
      }).toList();

      // Filter by search query if provided
      List<ProductItem> filteredProducts = products;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final queryLower = searchQuery.toLowerCase();
        filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(queryLower) ||
              product.shopName.toLowerCase().contains(queryLower);
        }).toList();
      }

      // Sort by distance
      filteredProducts.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      return filteredProducts;
    } catch (e) {
      throw Exception('Error getting products: $e');
    }
  }

  Future<ProductItem?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection(_productsCollection).doc(productId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return ProductItem.fromMap(doc.id, data);
    } catch (e) {
      throw Exception('Error getting product: $e');
    }
  }

  // ============ INVENTORY OPERATIONS ============

  Stream<List<InventoryItem>> getInventoryStream(String shopId) {
    return _firestore
        .collection(_inventoryCollection)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return InventoryItem.fromMap(doc.id, data);
      }).toList();
    });
  }

  Future<List<InventoryItem>> getInventory(String shopId) async {
    try {
      final snapshot = await _firestore
          .collection(_inventoryCollection)
          .where('shopId', isEqualTo: shopId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return InventoryItem.fromMap(doc.id, data);
      }).toList();
    } catch (e) {
      throw Exception('Error getting inventory: $e');
    }
  }

  Future<String> addInventoryItem({
    required String shopId,
    required String name,
    required String category,
    required double price,
    required bool inStock,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      final inventoryData = {
        'shopId': shopId,
        'name': name,
        'category': category,
        'price': price,
        'inStock': inStock,
        'shopLatitude': latitude,
        'shopLongitude': longitude,
        'shopAddress': address,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(_inventoryCollection).add(inventoryData);

      // Also create/update product entry
      final shopDoc = await _firestore.collection(_shopsCollection).doc(shopId).get();
      final shopData = shopDoc.data();
      
      if (shopData != null) {
        final productData = {
          'shopId': shopId,
          'shopName': shopData['shopName'] ?? 'Unknown Shop',
          'name': name,
          'category': category,
          'price': price,
          'inStock': inStock,
          'shopLatitude': latitude,
          'shopLongitude': longitude,
          'shopAddress': address,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection(_productsCollection).add(productData);
      }

      return docRef.id;
    } catch (e) {
      throw Exception('Error adding inventory item: $e');
    }
  }

  Future<void> updateInventoryItem(String itemId, {
    String? name,
    String? category,
    double? price,
    bool? inStock,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (category != null) updateData['category'] = category;
      if (price != null) updateData['price'] = price;
      if (inStock != null) updateData['inStock'] = inStock;

      await _firestore.collection(_inventoryCollection).doc(itemId).update(updateData);

      // Also update corresponding product
      final itemDoc = await _firestore.collection(_inventoryCollection).doc(itemId).get();
      final itemData = itemDoc.data();
      if (itemData != null) {
        final shopId = itemData['shopId'] as String;
        final productQuery = await _firestore
            .collection(_productsCollection)
            .where('shopId', isEqualTo: shopId)
            .where('name', isEqualTo: itemData['name'])
            .limit(1)
            .get();

        if (productQuery.docs.isNotEmpty) {
          final productUpdateData = <String, dynamic>{
            'updatedAt': FieldValue.serverTimestamp(),
          };
          if (name != null) productUpdateData['name'] = name;
          if (category != null) productUpdateData['category'] = category;
          if (price != null) productUpdateData['price'] = price;
          if (inStock != null) productUpdateData['inStock'] = inStock;

          await _firestore
              .collection(_productsCollection)
              .doc(productQuery.docs.first.id)
              .update(productUpdateData);
        }
      }
    } catch (e) {
      throw Exception('Error updating inventory item: $e');
    }
  }

  Future<void> deleteInventoryItem(String itemId) async {
    try {
      await _firestore.collection(_inventoryCollection).doc(itemId).delete();
    } catch (e) {
      throw Exception('Error deleting inventory item: $e');
    }
  }

  // ============ CATEGORY OPERATIONS ============

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection(_categoriesCollection)
          .orderBy('name')
          .get();

      if (snapshot.docs.isEmpty) {
        // Return default categories if none exist
        return _getDefaultCategories();
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      // Return default categories on error
      return _getDefaultCategories();
    }
  }

  List<Map<String, dynamic>> _getDefaultCategories() {
    return [
      {'name': 'All', 'icon': 'apps', 'color': '#2196F3'},
      {'name': 'Construction', 'icon': 'build', 'color': '#FF9800'},
      {'name': 'Electronics', 'icon': 'devices', 'color': '#9C27B0'},
      {'name': 'Stationery', 'icon': 'edit', 'color': '#2196F3'},
      {'name': 'Household', 'icon': 'home', 'color': '#4CAF50'},
      {'name': 'Furniture', 'icon': 'chair', 'color': '#795548'},
      {'name': 'Clothing', 'icon': 'checkroom', 'color': '#E91E63'},
      {'name': 'Food', 'icon': 'restaurant', 'color': '#F44336'},
    ];
  }
}

