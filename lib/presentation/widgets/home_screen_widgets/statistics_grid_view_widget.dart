import 'package:flutter/material.dart';
import '../../../core/utils/colors.dart';
import 'statistic_card_widget.dart';

class StatisticsGridViewWidget extends StatelessWidget {
  const StatisticsGridViewWidget({
    super.key,
    required this.totalLaunches,
    required this.upcomingLaunches,
    required this.totalCapsules,
    required this.totalRockets,
  });
  final int totalLaunches;
  final int upcomingLaunches;
  final int totalCapsules;
  final int totalRockets;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio:
            MediaQuery.of(context).size.width < 600 ? 3 / 2 : 4 / 1,
      ),
      children: [
        StatisticCardWidget(
            count: '$totalLaunches',
            label: 'Total Launches',
            color: Colors.blue),
        StatisticCardWidget(
            count: '$upcomingLaunches',
            label: 'Upcoming Launches',
            color: AppColors.secondary),
        StatisticCardWidget(
            count: '$totalCapsules',
            label: 'Total Capsules',
            color: AppColors.accent),
        StatisticCardWidget(
            count: '$totalRockets',
            label: 'Total Rockets',
            color: AppColors.success),
      ],
    );
  }
}
