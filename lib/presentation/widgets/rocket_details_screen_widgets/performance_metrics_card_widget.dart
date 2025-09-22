import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/presentation/utils/format_currency.dart';
import 'package:spacex_flutter_app/presentation/utils/format_date.dart';
import 'package:spacex_flutter_app/presentation/utils/get_status_color.dart';
import 'package:spacex_flutter_app/presentation/widgets/status_container_widget.dart';

import '../../../domain/entities/rocket_entity.dart';

class PerformanceMetricsCardWidget extends StatelessWidget {
  const PerformanceMetricsCardWidget({super.key, required this.rocket});
  final RocketEntity rocket;

  @override
  Widget build(BuildContext context) {
    final status = rocket.active ? 'Active' : 'Inactive';
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
                  'Performance Metrics',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildPerformanceMetrics(
                  context: context,
                  label: 'Status',
                  widget: StatusContainerWidget(
                      status: status, color: getStatusColor(status)),
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildPerformanceMetrics(
                  context: context,
                  label: 'Success Rate',
                  widget: Text(
                    '${rocket.successRate}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildPerformanceMetrics(
                  context: context,
                  label: 'Cost per Launch',
                  widget: Text(
                    formatCurrency(amount: rocket.costPerLaunch),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildPerformanceMetrics(
                  context: context,
                  label: 'First Flight',
                  widget: Text(
                    formatDate(date: rocket.firstFlight),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
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

Widget _buildPerformanceMetrics({
  required BuildContext context,
  required String label,
  required Widget widget,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
      widget
    ],
  );
}
