import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/category_item.dart';
import '../models/product_item.dart';
import '../widgets/product_card.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import 'product_detail_screen.dart';
import 'vendor_home_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  String _selectedCategory = 'All';
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  final List<CategoryItem> _categories = [
    CategoryItem(name: 'All', icon: Icons.apps, color: Colors.blue),
    CategoryItem(name: 'Construction', icon: Icons.build, color: Colors.orange),
    CategoryItem(name: 'Electronics', icon: Icons.devices, color: Colors.purple),
    CategoryItem(name: 'Stationery', icon: Icons.edit, color: Colors.blue),
    CategoryItem(name: 'Household', icon: Icons.home, color: Colors.green),
    CategoryItem(name: 'Furniture', icon: Icons.chair, color: Colors.brown),
    CategoryItem(name: 'Clothing', icon: Icons.checkroom, color: Colors.pink),
    CategoryItem(name: 'Food', icon: Icons.restaurant, color: Colors.red),
  ];

  // Sample products with shop locations (Addis Ababa coordinates)
  final List<ProductItem> _allProducts = [
    ProductItem(
      name: 'Cement (Dangote 50kg)',
      category: 'Construction',
      price: 780,
      distanceKm: 1.2, // Will be calculated dynamically
      shopName: 'Addis Construction Supply',
      inStock: true,
      shopLatitude: 9.0191,
      shopLongitude: 38.7556,
      shopAddress: 'Bole Road, Addis Ababa',
    ),
    ProductItem(
      name: '32" LED TV',
      category: 'Electronics',
      price: 8500,
      distanceKm: 3.5, // Will be calculated dynamically
      shopName: 'Merkato Electronics',
      inStock: true,
      shopLatitude: 9.0273,
      shopLongitude: 38.7569,
      shopAddress: 'Merkato, Addis Ababa',
    ),
    ProductItem(
      name: 'A4 Paper (500 sheets)',
      category: 'Stationery',
      price: 420,
      distanceKm: 0.8, // Will be calculated dynamically
      shopName: 'Piassa Stationery',
      inStock: true,
      shopLatitude: 9.0323,
      shopLongitude: 38.7494,
      shopAddress: 'Piassa, Addis Ababa',
    ),
    ProductItem(
      name: 'Steel Rebar 12mm',
      category: 'Construction',
      price: 550,
      distanceKm: 2.1, // Will be calculated dynamically
      shopName: 'Bole Hardware Store',
      inStock: true,
      shopLatitude: 9.0122,
      shopLongitude: 38.7899,
      shopAddress: 'Bole Sub-city, Addis Ababa',
    ),
    ProductItem(
      name: 'Laptop Stand',
      category: 'Electronics',
      price: 1200,
      distanceKm: 4.2, // Will be calculated dynamically
      shopName: 'Tech Hub Addis',
      inStock: false,
      shopLatitude: 9.0054,
      shopLongitude: 38.7636,
      shopAddress: 'Mexico, Addis Ababa',
    ),
    ProductItem(
      name: 'Office Chair',
      category: 'Furniture',
      price: 3500,
      distanceKm: 2.8, // Will be calculated dynamically
      shopName: 'Comfort Furniture',
      inStock: true,
      shopLatitude: 9.0089,
      shopLongitude: 38.7778,
      shopAddress: 'Cazanchise, Addis Ababa',
    ),
    ProductItem(
      name: 'Kitchen Set',
      category: 'Household',
      price: 2500,
      distanceKm: 1.5, // Will be calculated dynamically
      shopName: 'Home Essentials',
      inStock: true,
      shopLatitude: 9.0147,
      shopLongitude: 38.7524,
      shopAddress: 'Kazanches, Addis Ababa',
    ),
    ProductItem(
      name: 'Notebooks (Pack of 10)',
      category: 'Stationery',
      price: 180,
      distanceKm: 0.5, // Will be calculated dynamically
      shopName: 'School Supplies Co.',
      inStock: true,
      shopLatitude: 9.0181,
      shopLongitude: 38.7481,
      shopAddress: 'Arada, Addis Ababa',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    final position = await LocationService.getCurrentLocation();
    
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
      // Recalculate distances for all products
      _updateProductDistances();
    } else {
      setState(() {
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location access denied. Distances may not be accurate.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _updateProductDistances() {
    if (_currentPosition == null) return;

    setState(() {
      for (int i = 0; i < _allProducts.length; i++) {
        final product = _allProducts[i];
        if (product.shopLatitude != null && product.shopLongitude != null) {
          final distance = LocationService.calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            product.shopLatitude!,
            product.shopLongitude!,
          );
          // Update the distance in the product
          _allProducts[i] = product.copyWith(distanceKm: distance);
        }
      }
    });
  }

  List<ProductItem> get _filteredProducts {
    var filtered = List<ProductItem>.from(_allProducts);
    
    // Recalculate distances if we have current position
    if (_currentPosition != null) {
      filtered = filtered.map((product) {
        if (product.shopLatitude != null && product.shopLongitude != null) {
          final distance = LocationService.calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            product.shopLatitude!,
            product.shopLongitude!,
          );
          return product.copyWith(distanceKm: distance);
        }
        return product;
      }).toList();
    }
    
    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.shopName.toLowerCase().contains(query);
      }).toList();
    }
    // Sort by distance
    filtered.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = _buildHomeTab();
        break;
      case 1:
        body = _buildMapTab();
        break;
      case 2:
        body = _buildNotificationsTab();
        break;
      case 3:
        body = _buildProfileTab();
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        // Green header with search
        Container(
          color: Colors.green,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for any item...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: _isLoadingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.my_location, color: Colors.white),
                  onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                  tooltip: 'Refresh location',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        // Categories dropdown
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      items: _categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.name,
                          child: Row(
                            children: [
                              Icon(cat.icon, size: 20, color: cat.color),
                              const SizedBox(width: 8),
                              Text(cat.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Category grid
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = cat.name == _selectedCategory;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat.name;
                  });
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? cat.color.withOpacity(0.2) : cat.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? cat.color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon, size: 40, color: cat.color),
                      const SizedBox(height: 8),
                      Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: cat.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Products list
        Expanded(
          child: _filteredProducts.isEmpty
              ? const Center(
                  child: Text('No items found. Try a different search.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {},
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMapTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Vendors'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Map placeholder
          Container(
            color: Colors.grey.shade200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vendors will appear on map',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom sheet with nearby vendors
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Nearby Vendors',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: Icon(Icons.store, color: Colors.green.shade700),
                            ),
                            title: Text(product.shopName),
                            subtitle: Text('${product.distanceKm.toStringAsFixed(1)} km away'),
                            trailing: Text(
                              '${product.price.toStringAsFixed(0)} ETB',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          const Text(
            'User Name',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Vendor Mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VendorHomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}


