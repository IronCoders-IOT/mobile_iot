import 'package:flutter/material.dart';

class WaterRequestScreen extends StatelessWidget {
  const WaterRequestScreen({super.key});

  static Future<int?> show(BuildContext context) {
    return showDialog<int>(
      context: context,
      builder: (context) => const WaterRequestScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController litersController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Request Water',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 24),

            // Water icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF3498DB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.water_drop,
                color: Color(0xFF3498DB),
                size: 32,
              ),
            ),
            const SizedBox(height: 24),

            // Input field
            TextField(
              controller: litersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Liters',
                hintText: 'Enter amount of water',
                prefixIcon: const Icon(Icons.water_drop_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF3498DB).withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF3498DB),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Request button
                ElevatedButton(
                  onPressed: () {
                    final liters = int.tryParse(litersController.text);
                    if (liters != null && liters > 0) {
                      Navigator.pop(context, liters);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid amount of water'),
                          backgroundColor: Color(0xFFE74C3C),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
