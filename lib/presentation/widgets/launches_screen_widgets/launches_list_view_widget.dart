import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/presentation/widgets/launches_screen_widgets/timeline_tile_widget.dart';

class LaunchesListViewWidget extends StatelessWidget {
  const LaunchesListViewWidget({
    super.key,
    required this.launches,
    required this.isFetchingMore,
    required this.scrollController,
  });

  final List<LaunchEntity> launches;
  final bool isFetchingMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      itemCount: launches.length + 1,
      itemBuilder: (_, index) {
        if (index < launches.length) {
          return TimelineTileWidget(
            launch: launches[index],
          );
        } else {
          return isFetchingMore
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : const SizedBox.shrink();
        }
      },
      separatorBuilder: (_, __) => const SizedBox(
        height: 10,
      ),
    );
  }
}
