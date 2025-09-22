import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';
import 'package:spacex_flutter_app/presentation/screens/rocket_details_screen.dart';
import 'package:spacex_flutter_app/presentation/utils/format_date.dart';
import 'package:spacex_flutter_app/presentation/widgets/status_container_widget.dart';

import '../../utils/format_currency.dart';
import '../../utils/get_status_color.dart';

class RocketCardWidget extends StatelessWidget {
  final RocketEntity rocket;
  const RocketCardWidget({super.key, required this.rocket});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final status = rocket.active ? 'Active' : 'Inactive';

    return InkWell(
      onTap: () {
        Get.to(RocketDetailsScreen(rocketId: rocket.id));
      },
      child: Skeleton.leaf(
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: isDarkMode ? Colors.white : Colors.black,
                padding: const EdgeInsets.all(12),
                child: AspectRatio(
                  aspectRatio: 18 / 8,
                  child: Image.asset(
                    'assets/icons/rocket_icon.png',
                    color: isDarkMode ? Colors.black : Colors.white,
                    width: 50,
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rocket.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 6),
                    _buildRowWidget(
                      label: 'Status',
                      widget: StatusContainerWidget(
                        status: status,
                        color: getStatusColor(status),
                      ),
                      context: context,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildRowWidget(
                        label: 'Success Rate',
                        widget: Text(
                          '${rocket.successRate}%',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                        ),
                        context: context),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildRowWidget(
                      label: 'Cost per Launch',
                      widget: Text(
                        formatCurrency(amount: rocket.costPerLaunch),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                      ),
                      context: context,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _buildRowWidget(
                      label: 'First Flight',
                      widget: Text(
                        formatDate(date: rocket.firstFlight),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                      ),
                      context: context,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRowWidget({
  required String label,
  required Widget widget,
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
      ),
      widget
    ],
  );
}
