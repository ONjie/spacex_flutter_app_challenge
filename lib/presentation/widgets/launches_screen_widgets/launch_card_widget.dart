import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/presentation/screens/launch_details_screen.dart';
import 'package:spacex_flutter_app/presentation/utils/get_status_color.dart';
import 'package:spacex_flutter_app/presentation/widgets/status_container_widget.dart';

import '../../utils/format_launch_date.dart';

class LaunchCardWidget extends StatelessWidget {
  const LaunchCardWidget({super.key, required this.launch});
  final LaunchEntity launch;


  @override
  Widget build(BuildContext context) {
    final status = launch.upcoming ? 'UPCOMING' : 'COMPLETED';
    return InkWell(
      onTap: () {
        Get.to(LaunchDetailsScreen(launchId: launch.id,));
      },
      child: Skeleton.leaf(
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        launch.missionName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    StatusContainerWidget(
                      status: status,
                      color: getStatusColor(status),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  launch.rocketName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  formatLaunchDate(dateTime: launch.launchDateLocal),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  launch.details,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
