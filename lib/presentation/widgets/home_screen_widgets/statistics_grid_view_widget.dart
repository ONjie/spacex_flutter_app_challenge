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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 600;

    // Calculate a consistent card width for 2 columns
    final double cardWidth = isWide
        ? 250
        : (screenWidth / 2) - 24; // subtracting padding + spacing
    const double cardHeight = 120; // fixed height for equal layout

    return Wrap(
      spacing: 18,
      runSpacing: 18,
      alignment: WrapAlignment.center,
      children: [
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: StatisticCardWidget(
            count: '$totalLaunches',
            label: 'Total Launches',
            color: Colors.blue,
          ),
        ),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: StatisticCardWidget(
            count: '$upcomingLaunches',
            label: 'Upcoming Launches',
            color: AppColors.secondary,
          ),
        ),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: StatisticCardWidget(
            count: '$totalCapsules',
            label: 'Total Capsules',
            color: AppColors.accent,
          ),
        ),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: StatisticCardWidget(
            count: '$totalRockets',
            label: 'Total Rockets',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}
