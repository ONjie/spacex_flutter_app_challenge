import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';
import 'package:spacex_flutter_app/presentation/providers/rocket_provider.dart';
import 'package:spacex_flutter_app/presentation/widgets/error_state_widget.dart';
import 'package:spacex_flutter_app/presentation/widgets/rocket_screen_widgets/rockets_list_view_widget.dart';


// RocketsScreen displays a list of SpaceX rockets with their basic details.
// It supports loading, error handling, and shimmer effects while data is fetched.
class RocketsScreen extends StatefulWidget {
  const RocketsScreen({super.key});

  @override
  State<RocketsScreen> createState() => _RocketsScreenState();
}

class _RocketsScreenState extends State<RocketsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the list of rockets when the screen is first loaded
    Future.microtask(() {
      if (!mounted) return;

      Provider.of<RocketProvider>(context, listen: false).fetchRockets();
    });
  }

  //final double cardMinWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: SizedBox(
        width: screenWidth,
        child:
            Consumer<RocketProvider>(builder: (context, rocketProvider, child) {
          final isLoading = rocketProvider.isLoading;
          final rockets = rocketProvider.rockets;
          final error = rocketProvider.error;


          // Show error widget if fetching rockets fails
          if (error != null) {
            return ErrorStateWidget(
                errorMessage: error,
                onRetry: () async {
                  await rocketProvider.fetchRockets();
                });
          }

          // Show shimmer effect while loading rocket data
          return Skeletonizer(
            enabled: isLoading,
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
                  Text(
                    'Rocket Gallery',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth > 600 ? 40 : 28,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "SpaceX rocket fleet",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth > 600 ? 20 : 16,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: RocketsListViewWidget(
                        rockets: isLoading
                            ? List.generate(
                                3, (index) => RocketEntity.rocketDummy)
                            : rockets),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
