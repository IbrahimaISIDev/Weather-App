import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    bool isLocationDisabled = message == 'Services de localisation désactivés';
    bool isPermissionDenied = message == 'Permission localisation refusée';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
                if (isLocationDisabled || isPermissionDenied) ...[
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (isLocationDisabled) {
                        context.read<WeatherProvider>().openLocationSettings();
                      } else {
                        context.read<WeatherProvider>().openAppSettings();
                      }
                    },
                    icon: const Icon(Icons.settings),
                    label: Text(isLocationDisabled ? 'Activer GPS' : 'Paramètres'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
