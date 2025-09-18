import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';

class RecentLaunchesCardWidget extends StatelessWidget {
  const RecentLaunchesCardWidget({super.key, required this.launches});

  final List<LaunchEntity> launches;

  @override
  Widget build(BuildContext context) {
    final sortedLaunches = List<LaunchEntity>.from(launches)
      ..sort((a, b) => b.launchDateLocal.compareTo(a.launchDateLocal));

    // Take the top 3 most recent launches
    final recentLaunches = sortedLaunches.take(3).toList();

    final dateFormatter = DateFormat('MMM d, yyyy');
    return Skeleton.leaf(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Launches',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentLaunches.length,
                itemBuilder: (context, index) {
                  final launch = recentLaunches[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      launch.missionName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    subtitle: Text(
                      '${dateFormatter.format(launch.launchDateLocal)} - ${launch.rocketName}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      //TODO: Handle tap
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
