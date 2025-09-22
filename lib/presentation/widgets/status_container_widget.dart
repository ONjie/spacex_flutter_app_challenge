import 'package:flutter/material.dart';


// A reusable widget that displays a status label with a colored background.
// Typically used to show the status of a launch, rocket, or capsule (e.g., "Upcoming", "Completed") 
// with a visually distinct color.
class StatusContainerWidget extends StatelessWidget {
  const StatusContainerWidget({
    super.key,
    required this.status,
    required this.color,
  });
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.5),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        status,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
      ),
    );
  }
}
