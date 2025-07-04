import 'package:flutter/material.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:mobile_iot/analytics/infrastructure/data_sources/water_request_api_service.dart';
import 'package:mobile_iot/analytics/infrastructure/repositories/water_request_repository_impl.dart';

class WaterRequestScreen extends StatefulWidget {
  const WaterRequestScreen({super.key});

  static Future<int?> show(BuildContext context) {
    return showDialog<int>(
      context: context,
      builder: (context) => const WaterRequestScreen(),
    );
  }

  @override
  State<WaterRequestScreen> createState() => _WaterRequestScreenState();
}

class _WaterRequestScreenState extends State<WaterRequestScreen> {
  final TextEditingController litersController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendRequest(BuildContext context) async {
    final liters = int.tryParse(litersController.text);
    if (liters == null || liters <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount of analytics'),
          backgroundColor: Color(0xFFE74C3C),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final storage = SecureStorageService();
      final token = await storage.getToken();
      if (token == null) throw Exception('No authentication token found');
      final repo = WaterRequestRepositoryImpl(WaterRequestApiService());
      await repo.createWaterRequest(
        token,
        liters.toString(),
        'IN_PROGRESS',
        DateTime.now().toIso8601String(),
      );
      if (mounted) {
        Navigator.pop(context, liters);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Water request sent!'),
            backgroundColor: Color(0xFF27AE60),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send request: \\${e.toString()}'),
          backgroundColor: const Color(0xFFE74C3C),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                hintText: 'Enter amount of analytics',
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
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                  onPressed: _isLoading ? null : () => _sendRequest(context),
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
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
