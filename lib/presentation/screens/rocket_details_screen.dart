import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/presentation/providers/rocket_provider.dart';
import 'package:spacex_flutter_app/presentation/widgets/error_state_widget.dart';
import 'package:spacex_flutter_app/presentation/widgets/rocket_details_screen_widgets/description_card_widget.dart';
import 'package:spacex_flutter_app/presentation/widgets/rocket_details_screen_widgets/performance_metrics_card_widget.dart';
import 'package:spacex_flutter_app/presentation/widgets/rocket_details_screen_widgets/physical_specification_card_widget.dart';


// RocketDetailsScreen displays detailed information about a single rocket,
// including description, physical specifications, and performance metrics.
class RocketDetailsScreen extends StatefulWidget {
  const RocketDetailsScreen({super.key, required this.rocketId});

  final String rocketId;

  @override
  State<RocketDetailsScreen> createState() => _RocketDetailsScreenState();
}

class _RocketDetailsScreenState extends State<RocketDetailsScreen> {
  @override
  void initState() {
    super.initState();
     // Fetch rocket details by ID when the screen is initialized
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<RocketProvider>(context, listen: false)
          .fetchRocketById(id: widget.rocketId);
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
        'Rocket Details',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
          color:  Colors.white,
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
        child: Consumer<RocketProvider>(
          builder: (context, rocketProvider, child) {
            final isLoading = rocketProvider.isLoading;
            final rocket = rocketProvider.rocket;
            final error = rocketProvider.error;

            // Show error widget if fetching rocket details fails
            if (error != null) {
              return ErrorStateWidget(
                errorMessage: error,
                onRetry: () async {
                  await rocketProvider.fetchRocketById(id: widget.rocketId);
                },
              );
            }

             // Show shimmer effect while loading rocket details
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
                              rocket!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              rocket.type,
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
                            DescriptionCardWidget(
                              description: rocket.description,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            PhysicalSpecificationCardWidget(rocket: rocket),
                             const SizedBox(
                              height: 12,
                            ),
                            PerformanceMetricsCardWidget(rocket: rocket,)
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
}
