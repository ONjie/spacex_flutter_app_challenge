import 'package:flutter/material.dart';


// A reusable widget to display an error message with a retry button.
// Typically used when an API call or data fetch fails, allowing the user
// to retry the operation.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({super.key, required this.errorMessage, required this.onRetry});

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          errorMessage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
