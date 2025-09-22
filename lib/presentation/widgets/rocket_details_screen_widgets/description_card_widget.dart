import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DescriptionCardWidget extends StatelessWidget {
  const DescriptionCardWidget({super.key, required this.description});
  final String description;

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
                  'Description',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
