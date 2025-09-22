import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/presentation/utils/get_status_color.dart';
import 'package:spacex_flutter_app/presentation/widgets/launches_screen_widgets/launch_card_widget.dart';

class TimelineTileWidget extends StatelessWidget {
  final LaunchEntity launch;

  const TimelineTileWidget({
    super.key,
    required this.launch,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final lineColor = isDarkMode ? Colors.white : Colors.black;
    final status = launch.upcoming ? 'UPCOMING': 'COMPLETED';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Skeleton.leaf(
              child: Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(bottom: 10),
                decoration:  BoxDecoration(
                  color: getStatusColor(status),
                  shape: BoxShape.circle,
                ),
              ),
            ),
              Skeleton.leaf(
                child: Container(
                  width: 2,
                  height: 136,
                  color: lineColor,
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LaunchCardWidget(launch: launch)
        ),
      ],
    );
  }
}
