import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';

class OnlineStatusIndicator extends StatelessWidget {
  const OnlineStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternetConnectionStatus>(
      // Use GetIt to retrieve the instance, as it is registered in CoreModule
      stream: GetIt.I<InternetConnectionChecker>().onStatusChange,
      initialData: InternetConnectionStatus.connected, // Optimistic
      builder: (context, snapshot) {
        final isOnline = snapshot.data == InternetConnectionStatus.connected;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOnline ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isOnline ? Colors.green : Colors.red),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 8, color: isOnline ? Colors.green : Colors.red),
              const SizedBox(width: 4),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  color: isOnline ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
