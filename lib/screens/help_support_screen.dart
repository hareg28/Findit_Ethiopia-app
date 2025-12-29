import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Section
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.help_outline, size: 64, color: Colors.green.shade700),
                  const SizedBox(height: 16),
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions or contact our support team',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // FAQ Section
          _buildSectionHeader('Frequently Asked Questions'),
          _buildFAQItem(
            question: 'How do I search for items?',
            answer:
                'Use the search bar on the home screen to type the name of the item you\'re looking for. You can also filter by category using the category dropdown or category icons.',
          ),
          _buildFAQItem(
            question: 'How is distance calculated?',
            answer:
                'Distance is calculated based on your current location and the shop\'s location. Make sure to enable location services for accurate distance measurements.',
          ),
          _buildFAQItem(
            question: 'How do I become a vendor?',
            answer:
                'Go to your Profile tab, tap on "Vendor Mode" to access the vendor dashboard. From there, you can add your shop information and manage your inventory.',
          ),
          _buildFAQItem(
            question: 'How do I update my shop information?',
            answer:
                'Navigate to Vendor Mode from your profile, then you can update your shop details, add or remove items from your inventory, and manage your shop status.',
          ),
          _buildFAQItem(
            question: 'What if I can\'t find an item?',
            answer:
                'Try searching with different keywords or browse by category. You can also contact vendors directly if they have contact information listed.',
          ),
          const SizedBox(height: 24),

          // Contact Support Section
          _buildSectionHeader('Contact Support'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: const Text('Email Support'),
                  subtitle: const Text('support@finditethiopia.com'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email: support@finditethiopia.com'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text('Phone Support'),
                  subtitle: const Text('+251 9 00 000 000'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phone: +251 9 00 000 000'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.chat, color: Colors.green),
                  title: const Text('Live Chat'),
                  subtitle: const Text('Available 9 AM - 6 PM'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Live chat coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions Section
          _buildSectionHeader('Quick Actions'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bug_report, color: Colors.orange),
                  title: const Text('Report a Bug'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showReportBugDialog(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lightbulb, color: Colors.blue),
                  title: const Text('Suggest a Feature'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showSuggestFeatureDialog(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: const Text('Rate the App'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your interest! Rating coming soon.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Information
          _buildSectionHeader('App Information'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Version', '1.0.0'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Last Updated', '2024'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Developer', 'FindIt Ethiopia Team'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline, color: Colors.green),
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showReportBugDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Describe the bug you encountered...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for reporting! We\'ll look into it.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showSuggestFeatureDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggest a Feature'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Tell us about your feature idea...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your suggestion!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

