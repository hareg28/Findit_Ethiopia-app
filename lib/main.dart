import 'package:flutter/material.dart';

void main() {
  runApp(const FindItEthiopiaApp());
}

class FindItEthiopiaApp extends StatelessWidget {
  const FindItEthiopiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindIt Ethiopia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      // This lets the system back button work nicely.
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
    );
  }
}

/// Simple splash screen that shows the logo before entering the app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00695C), Color(0xFF26A69A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.location_on,
                size: 72,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'FindIt Ethiopia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// First screen: choose whether you are a shopper or a vendor.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00695C), Color(0xFF26A69A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'FindIt Ethiopia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Quickly find nearby shops and vendors for anything you need.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                _RoleButton(
                  icon: Icons.search,
                  title: 'I am a Shopper',
                  description: 'Search items, compare prices, and find nearby shops.',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ShopperHomeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _RoleButton(
                  icon: Icons.storefront,
                  title: 'I am a Vendor',
                  description: 'Manage your shop, inventory, and visibility.',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const VendorHomeScreen()),
                    );
                  },
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Amharic • Afaan Oromo • English',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.green.shade700, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

/// Shopper side: search items and see nearby vendors (mock data for now).
class ShopperHomeScreen extends StatefulWidget {
  const ShopperHomeScreen({super.key});

  @override
  State<ShopperHomeScreen> createState() => _ShopperHomeScreenState();
}

class _ShopperHomeScreenState extends State<ShopperHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<_VendorItem> _allVendors = [
    const _VendorItem(
      shopName: 'Addis Construction Supply',
      itemName: 'Cement (Dangote 50kg)',
      price: 780,
      distanceKm: 1.2,
      inStock: true,
    ),
    const _VendorItem(
      shopName: 'Merkato Electronics',
      itemName: '32" LED TV',
      price: 8500,
      distanceKm: 3.5,
      inStock: true,
    ),
    const _VendorItem(
      shopName: 'Piassa Stationery',
      itemName: 'A4 Paper (500 sheets)',
      price: 420,
      distanceKm: 0.8,
      inStock: false,
    ),
  ];

  String _query = '';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final filtered = _allVendors.where((v) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return v.itemName.toLowerCase().contains(q) ||
          v.shopName.toLowerCase().contains(q);
    }).toList();

    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for cement, TV, paper...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return _VendorCard(item: item);
                },
              ),
            ),
          ],
        );
        break;
      case 1:
        body = const Center(
          child: Text('Notifications & offers will appear here.'),
        );
        break;
      case 2:
        body = const Center(
          child: Text('Profile & settings will appear here.'),
        );
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text('Find Items Nearby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _VendorItem {
  final String shopName;
  final String itemName;
  final double price;
  final double distanceKm;
  final bool inStock;

  const _VendorItem({
    required this.shopName,
    required this.itemName,
    required this.price,
    required this.distanceKm,
    required this.inStock,
  });
}

class _VendorCard extends StatelessWidget {
  final _VendorItem item;

  const _VendorCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VendorDetailScreen(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.store,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.shopName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.distanceKm.toStringAsFixed(1)} km away',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.price.toStringAsFixed(0)} ETB',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      item.inStock ? 'In stock' : 'Out of stock',
                      style: TextStyle(
                        color: item.inStock ? Colors.green.shade800 : Colors.red,
                      ),
                    ),
                    backgroundColor: item.inStock
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detailed view of a selected vendor + item.
class VendorDetailScreen extends StatelessWidget {
  final _VendorItem item;

  const VendorDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(item.shopName),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.itemName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${item.price.toStringAsFixed(0)} ETB',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(item.inStock ? 'In stock' : 'Out of stock'),
                  backgroundColor: item.inStock
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 4),
                    Text('${item.distanceKm.toStringAsFixed(1)} km away'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Shop details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Address: Example street, Addis Ababa\n'
              'Open hours: 8:00 AM - 6:00 PM\n'
              'Phone: +251 9 00 00 000',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // In a real app, this would open maps with navigation.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigation to shop would open here.'),
                    ),
                  );
                },
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vendor side: simple inventory management mock.
class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  bool _shopOpen = true;
  final List<_InventoryItem> _inventory = [
    _InventoryItem(name: 'Cement (Dangote 50kg)', price: 780, inStock: true),
    _InventoryItem(name: 'Rebar 12mm (1 piece)', price: 550, inStock: true),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text('Vendor Dashboard'),
        actions: [
          Row(
            children: [
              Text(
                _shopOpen ? 'Open' : 'Closed',
                style: TextStyle(
                  color: _shopOpen ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: _shopOpen,
                onChanged: (value) {
                  setState(() {
                    _shopOpen = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Inventory',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _inventory.length,
                itemBuilder: (context, index) {
                  final item = _inventory[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('${item.price.toStringAsFixed(0)} ETB'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.inStock ? 'In stock' : 'Out',
                            style: TextStyle(
                              color: item.inStock
                                  ? Colors.green.shade700
                                  : Colors.red,
                            ),
                          ),
                          Switch(
                            value: item.inStock,
                            onChanged: (value) {
                              setState(() {
                                _inventory[index] =
                                    item.copyWith(inStock: value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openAddItemDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  void _openAddItemDialog(BuildContext context) {
    _nameController.clear();
    _priceController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Inventory Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (ETB)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final priceText = _priceController.text.trim();
                if (name.isEmpty || priceText.isEmpty) return;
                final price = double.tryParse(priceText);
                if (price == null) return;

                setState(() {
                  _inventory.add(
                    _InventoryItem(name: name, price: price, inStock: true),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _InventoryItem {
  final String name;
  final double price;
  final bool inStock;

  _InventoryItem({
    required this.name,
    required this.price,
    required this.inStock,
  });

  _InventoryItem copyWith({String? name, double? price, bool? inStock}) {
    return _InventoryItem(
      name: name ?? this.name,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
    );
  }
}
