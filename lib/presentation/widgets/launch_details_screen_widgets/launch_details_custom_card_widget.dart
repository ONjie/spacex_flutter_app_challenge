import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LaunchDetailsCustomCardWidget extends StatelessWidget {
  const LaunchDetailsCustomCardWidget({
    super.key,
    required this.label,
    required this.widget,
  });
  final String label;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Skeleton.leaf(
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: 12,
                ),
                widget
              ],
            ),
          ),
        ),
      ),
    );
  }
}
