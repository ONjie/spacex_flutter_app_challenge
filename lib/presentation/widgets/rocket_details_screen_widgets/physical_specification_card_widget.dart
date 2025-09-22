import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../domain/entities/rocket_entity.dart';

class PhysicalSpecificationCardWidget extends StatelessWidget {
  const PhysicalSpecificationCardWidget({super.key, required this.rocket});
  final RocketEntity rocket;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern();
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
                  'Physical Specifications',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildSpecificationsRow(
                  label: 'Height',
                  value:
                      '${rocket.heightInMeters}m (${rocket.heightInFeet}ft)',
                  context: context,
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildSpecificationsRow(
                  label: 'Diameter',
                  value:
                      '${rocket.diameterInMeters}m (${rocket.diameterInFeet}ft)',
                  context: context,
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildSpecificationsRow(
                  label: 'Mass',
                  value:
                      '${numberFormat.format(rocket.massInKg)}kg (${numberFormat.format(rocket.massInLb)}ft)',
                  context: context,
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildSpecificationsRow(
                  label: 'Stages',
                  value: '${rocket.stages}',
                  context: context,
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildSpecificationsRow(
                  label: 'Booster',
                  value: '${rocket.boosters}',
                  context: context,
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildSpecificationsRow(
                  label: 'Engines',
                  value: '${rocket.numberOfEngines}',
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSpecificationsRow({
  required String label,
  required String value,
  required BuildContext context,
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
      Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
      ),
    ],
  );
}
