import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatisticCardWidget extends StatelessWidget {
const StatisticCardWidget({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  final String count;
  final String label;
  final Color color;
  

  @override
  Widget build(BuildContext context) {
    return Skeleton.leaf(
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
      
            children: [
              Text(
                count,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
