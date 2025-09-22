import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/presentation/screens/capsule_details_screen.dart';
import 'package:spacex_flutter_app/presentation/utils/get_status_color.dart';
import 'package:spacex_flutter_app/presentation/widgets/status_container_widget.dart';

import '../../../domain/entities/capsule_entity.dart';

class CapsuleCardWidget extends StatelessWidget {
  const CapsuleCardWidget({super.key, required this.capsule});

  final CapsuleEntity capsule;

  @override
  Widget build(BuildContext context) {
    final status = capsule.status;
    return Skeleton.leaf(
      child: InkWell(
        onTap: () {
          Get.to(CapsuleDetailsScreen(capsuleId: capsule.id));
        },
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/capsule_icon.png',
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(capsule.type,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                        Text(
                          '${capsule.reuseCount} reuses',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusContainerWidget(
                    status: status,
                    color: getStatusColor(status))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
