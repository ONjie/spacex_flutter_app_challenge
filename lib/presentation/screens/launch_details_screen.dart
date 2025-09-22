import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/presentation/providers/launch_provider.dart';
import 'package:spacex_flutter_app/presentation/utils/format_launch_date.dart';
import 'package:spacex_flutter_app/presentation/utils/get_status_color.dart';
import 'package:spacex_flutter_app/presentation/widgets/launch_details_screen_widgets/launch_details_custom_card_widget.dart';
import 'package:spacex_flutter_app/presentation/widgets/status_container_widget.dart';

import '../../domain/entities/launch_entity.dart';
import '../widgets/error_state_widget.dart';


// Launch Details Screen shows detailed information about a single SpaceX launch
class LaunchDetailsScreen extends StatefulWidget {
  const LaunchDetailsScreen({super.key, required this.launchId});
  final String launchId;

  @override
  State<LaunchDetailsScreen> createState() => _LaunchDetailsScreenState();
}

class _LaunchDetailsScreenState extends State<LaunchDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch launch details by ID when screen initializes
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<LaunchProvider>(context, listen: false)
          .fetchLaunchById(id: widget.launchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context: context),
      body: _buildBody(context: context, isDarkMode: isDarkMode),
    );
  }

  AppBar _buildAppBar({
    required BuildContext context,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Launch Details',
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required bool isDarkMode,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Consumer<LaunchProvider>(
          builder: (context, launchProvider, _) {
            final isLoading = launchProvider.isLoading;
            final launch = launchProvider.launch;
            final error = launchProvider.error;

             // Display error widget if fetching fails
            if (error != null) {
              return ErrorStateWidget(
                errorMessage: error,
                onRetry: () async {
                  await launchProvider.fetchLaunchById(id: widget.launchId);
                },
              );
            }

             // Show skeleton loading effect while fetching launch details
            return Skeletonizer(
              enabled: isLoading || launch == null,
              effect: ShimmerEffect(
                baseColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                highlightColor:
                    isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
                duration: const Duration(milliseconds: 1200),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    16,
                    12,
                    0,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 14 / 4,
                              child: Image.asset(
                                'assets/icons/rocket_icon.png',
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              launch!.missionName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              launch.rocketName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                             // Card for mission description
                            LaunchDetailsCustomCardWidget(
                              label: 'Description',
                              widget: Text(
                                launch.details,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                             // Card for launch info like status and date/time
                            _buildLaunchInfo(launch: launch),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  // Builds a card displaying launch information (status & date/time)
  Widget _buildLaunchInfo({required LaunchEntity launch}) {
    final status = launch.upcoming ? "UPCOMING" : "COMPLETED";
    return LaunchDetailsCustomCardWidget(
      label: 'Launch Information',
      widget: Column(
        children: [
          _buildInfo(
            infoLabel: 'Launch Status',
            widget: StatusContainerWidget(
              color: getStatusColor(status),
              status: status,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          _buildInfo(
            infoLabel: 'Date & Time',
            widget: Text(
              formatLaunchDate(dateTime: launch.launchDateLocal),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }


  // Builds a single info row with a label and corresponding widget
  Widget _buildInfo({required String infoLabel, required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          infoLabel,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        widget
      ],
    );
  }
}
