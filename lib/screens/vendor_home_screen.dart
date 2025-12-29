import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/inventory_item.dart';
import '../services/location_service.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  bool _shopOpen = true;
  final List<InventoryItem> _inventory = [
    InventoryItem(name: 'Cement (Dangote 50kg)', price: 780, inStock: true),
    InventoryItem(name: 'Rebar 12mm (1 piece)', price: 550, inStock: true),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  double? _shopLatitude;
  double? _shopLongitude;
  bool _isLoadingLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Vendor Dashboard'),
        actions: [
          Row(
            children: [
              Text(
                _shopOpen ? 'Open' : 'Closed',
                style: TextStyle(
                  color: _shopOpen ? Colors.white : Colors.red.shade200,
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
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Row(
              children: [
                const Icon(Icons.store, size: 40, color: Colors.green),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Shop',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _shopOpen ? 'Shop is Open' : 'Shop is Closed',
                        style: TextStyle(
                          color: _shopOpen ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Your Inventory',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ..._inventory.map((item) {
                  final index = _inventory.indexOf(item);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.inventory, color: Colors.green.shade700),
                      ),
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
                                _inventory[index] = item.copyWith(inStock: value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openAddItemDialog(context);
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    final position = await LocationService.getCurrentLocation();
    
    if (position != null) {
      setState(() {
        _shopLatitude = position.latitude;
        _shopLongitude = position.longitude;
        _isLoadingLocation = false;
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location set: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      setState(() {
        _isLoadingLocation = false;
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not get location. Please enable location services.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openAddItemDialog(BuildContext context) {
    _nameController.clear();
    _priceController.clear();
    _addressController.clear();
    _shopLatitude = null;
    _shopLongitude = null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Inventory Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price (ETB)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Shop Address (Optional)',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., Bole Road, Addis Ababa',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Shop Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_shopLatitude != null && _shopLongitude != null)
                            Text(
                              'Lat: ${_shopLatitude!.toStringAsFixed(6)}\nLng: ${_shopLongitude!.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                              ),
                            )
                          else
                            const Text(
                              'No location set',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _isLoadingLocation
                                ? null
                                : () async {
                                    await _getCurrentLocation();
                                    setDialogState(() {});
                                  },
                            icon: _isLoadingLocation
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.location_on),
                            label: Text(_isLoadingLocation
                                ? 'Getting location...'
                                : 'Use Current Location'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Note: Location is required for customers to find your shop',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
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
                    if (name.isEmpty || priceText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in item name and price'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (_shopLatitude == null || _shopLongitude == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please set shop location'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    final price = double.tryParse(priceText);
                    if (price == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid price'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _inventory.add(
                        InventoryItem(
                          name: name,
                          price: price,
                          inStock: true,
                          shopLatitude: _shopLatitude,
                          shopLongitude: _shopLongitude,
                          shopAddress: _addressController.text.trim().isEmpty
                              ? null
                              : _addressController.text.trim(),
                        ),
                      );
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}


