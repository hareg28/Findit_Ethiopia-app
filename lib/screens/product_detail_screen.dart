import 'package:flutter/material.dart';
import '../models/product_item.dart';
import '../services/location_service.dart';
import 'main_home_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductItem product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double? _calculatedDistance;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    if (widget.product.shopLatitude == null || widget.product.shopLongitude == null) {
      setState(() {
        _calculatedDistance = widget.product.distanceKm;
      });
      return;
    }

    setState(() {
      _isLoadingLocation = true;
    });

    final position = await LocationService.getCurrentLocation();
    
    if (position != null) {
      setState(() {
        _calculatedDistance = LocationService.calculateDistance(
          position.latitude,
          position.longitude,
          widget.product.shopLatitude!,
          widget.product.shopLongitude!,
        );
        _isLoadingLocation = false;
      });
    } else {
      setState(() {
        _calculatedDistance = widget.product.distanceKm;
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDistance = _calculatedDistance ?? widget.product.distanceKm;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainHomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.product.category,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.product.price.toStringAsFixed(0)} ETB',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _isLoadingLocation
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(Icons.refresh, size: 20, color: Colors.green.shade700),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: _calculateDistance,
                                  tooltip: 'Refresh distance',
                                ),
                          const SizedBox(width: 4),
                          Icon(Icons.location_on, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text(
                            '${displayDistance.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Shop Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.store),
                      title: Text(widget.product.shopName),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Address'),
                      subtitle: Text(widget.product.shopAddress ?? 'Address not provided'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Open Hours'),
                      subtitle: Text('8:00 AM - 6:00 PM'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                      subtitle: Text('+251 9 00 00 000'),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: widget.product.inStock ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        widget.product.inStock ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          color: widget.product.inStock ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigation to shop would open here.'),
                    ),
                  );
                },
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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


