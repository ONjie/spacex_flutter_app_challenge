import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/presentation/widgets/home_screen_widgets/recent_launches_card_widget.dart';
import 'package:spacex_flutter_app/presentation/widgets/home_screen_widgets/statistics_grid_view_widget.dart';

import '../../domain/entities/launch_entity.dart';
import '../providers/capsule_provider.dart';
import '../providers/launch_provider.dart';
import '../providers/rocket_provider.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/home_screen_widgets/theme_toggle_icon_widget.dart';


// Main Home Screen displaying summary and recent launches
// of SpaceX capsules, rockets, and launches.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    // Fetch initial data from all providers asynchronously
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<LaunchProvider>(context, listen: false).fetchLaunches();
      Provider.of<CapsuleProvider>(context, listen: false).fetchCapsules();
      Provider.of<RocketProvider>(context, listen: false).fetchRockets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: _buildAppBar(context: context),
        body: _buildBody(context: context));
  }

  AppBar _buildAppBar({required BuildContext context}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'SpaceX Explorer',
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      centerTitle: true,
      actions: const [
        ThemeToggleIconWidget(),
      ],
    );
  }

  Widget _buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Consumer3<LaunchProvider, CapsuleProvider, RocketProvider>(
          builder: (context, launchProvider, capsuleProvider, rocketProvider,
              child) {
            final isLoading = launchProvider.isLoading ||
                capsuleProvider.isLoading ||
                rocketProvider.isLoading;

           
            final error = launchProvider.error ??
                capsuleProvider.error ??
                rocketProvider.error;

             // Show error state if any provider has an error
            if (error != null) {
              return ErrorStateWidget(
                errorMessage: error,
                onRetry: () {
                  launchProvider.fetchLaunches();
                  capsuleProvider.fetchCapsules();
                  rocketProvider.fetchRockets();
                },
              );
            }

            // Show shimmer loading effect while fetching data
            return Skeletonizer(
              enabled: isLoading,
              effect: ShimmerEffect(
                baseColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                highlightColor:
                    isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
                duration: const Duration(milliseconds: 1200),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                  child: Column(
                    children: [
                      Text(
                        'Explore SpaceX capsules, rockets, and launches',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 12),
                       // Statistics grid displaying summary counts
                      StatisticsGridViewWidget(
                        totalLaunches:
                            isLoading ? 0 : launchProvider.launches.length,
                        upcomingLaunches: isLoading
                            ? 0
                            : launchProvider.launches
                                .where((l) => l.upcoming)
                                .length,
                        totalCapsules:
                            isLoading ? 0 : capsuleProvider.capsules.length,
                        totalRockets:
                            isLoading ? 0 : rocketProvider.rockets.length,
                      ),
                      const SizedBox(height: 16),
                      RecentLaunchesCardWidget(
                        launches: isLoading
                            ? List.generate(
                                3, (index) => LaunchEntity.dummyLaunch)
                            : launchProvider.launches,
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
}
