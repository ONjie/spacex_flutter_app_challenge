import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/presentation/providers/launch_provider.dart';
import 'package:spacex_flutter_app/presentation/screens/search_results_screen.dart';
import 'package:spacex_flutter_app/presentation/widgets/error_state_widget.dart';

import '../widgets/launches_screen_widgets/launches_list_view_widget.dart';


// LaunchesScreen displays a paginated list of SpaceX launches with
// pull-to-refresh, infinite scroll, and search functionality.
class LaunchesScreen extends StatefulWidget {
  const LaunchesScreen({super.key});

  @override
  State<LaunchesScreen> createState() => _LaunchesScreenState();
}

class _LaunchesScreenState extends State<LaunchesScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Fetch initial page of launches when screen loads
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<LaunchProvider>(context, listen: false)
          .fetchLaunchesByPagination();
    });

    // Add listener to implement infinite scrolling
    _scrollController.addListener(() {
      final provider = context.read<LaunchProvider>();
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        provider.fetchLaunchesByPagination();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _buildBody(context: context));
  }

  Widget _buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child:
            Consumer<LaunchProvider>(builder: (context, launchProvider, _) {
          final launches = launchProvider.paginatedLaunches;
          final isLoading = launchProvider.isLoading;
          final error = launchProvider.error;

          // Display error widget if fetching launches fails
          if (error != null) {
            return ErrorStateWidget(
              errorMessage: error,
              onRetry: () async {
                launchProvider.refreshLaunches();
              },
            );
          }

          // Enable pull-to-refresh
          return RefreshIndicator(
            onRefresh: () async {
              launchProvider.refreshLaunches();
            },
            // Display shimmer effect while loading
            child: Skeletonizer(
              enabled: isLoading ,
              effect: ShimmerEffect(
                baseColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                highlightColor:
                    isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
                duration: const Duration(milliseconds: 1200),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      screenWidth: screenWidth,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: LaunchesListViewWidget(
                        launches: isLoading
                            ? List.generate(
                                4,
                                (index) => LaunchEntity.dummyLaunch,
                              )
                            : launches,
                        isFetchingMore: launchProvider.isFetchingMore,
                        scrollController: _scrollController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

// Builds the header row with screen title, subtitle, and search button
  Widget _buildHeader({required double screenWidth, required bool isDarkMode}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Launch Timeline',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth > 600 ? 40 : 28,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Recent and upcoming missions",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth > 600 ? 20 : 16,
                  ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Get.to(const SearchResultsScreen());
          },
          icon: const Icon(
            CupertinoIcons.search,
            size: 30,
          ),
        )
      ],
    );
  }
}
