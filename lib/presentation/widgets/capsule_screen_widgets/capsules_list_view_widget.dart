import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import 'capsule_card_widget.dart';

class CapsulesListViewWidget extends StatelessWidget {
  const CapsulesListViewWidget({
    super.key,
    required this.capsules,
    required this.scrollController,
    required this.isFetchingMore,
  });
  final List<CapsuleEntity> capsules;
  final ScrollController scrollController;
  final bool isFetchingMore;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      itemCount: capsules.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        if (index < capsules.length) {
          return CapsuleCardWidget(capsule: capsules[index]);
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
    );
  }
}
