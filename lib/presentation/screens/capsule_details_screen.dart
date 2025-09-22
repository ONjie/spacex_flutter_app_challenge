import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/presentation/widgets/error_state_widget.dart';
import 'package:spacex_flutter_app/presentation/widgets/status_container_widget.dart';

import '../providers/capsule_provider.dart';
import '../utils/get_status_color.dart';


// Screen that displays the details of a single SpaceX capsule.
// Fetches the capsule by its capsuleId and shows its type, status,
// and reuse count. Uses loading shimmer, error handling, and responsive layout.
class CapsuleDetailsScreen extends StatefulWidget {
  const CapsuleDetailsScreen({super.key, required this.capsuleId});
  final String capsuleId;

  @override
  State<CapsuleDetailsScreen> createState() => _CapsuleDetailsScreenState();
}

class _CapsuleDetailsScreenState extends State<CapsuleDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the capsule data when the screen is initialized
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<CapsuleProvider>(context, listen: false)
          .fetchCapsuleById(id: widget.capsuleId);
    });
  }

  @override
  Widget build(BuildContext context) {
     // Determine if the app is in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context: context),
      body: _buildBody(context: context, isDarkMode: isDarkMode),
    );
  }

  AppBar _buildAppBar({required BuildContext context}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Capsule Details',
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

  Widget _buildBody({required BuildContext context, required bool isDarkMode}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return SafeArea(
      child: SizedBox(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
          child: Consumer<CapsuleProvider>(
            builder: (context, capsuleProvider, child) {
              final isLoading = capsuleProvider.isLoading;
              final error = capsuleProvider.error;
              final capsule = capsuleProvider.capsule!;

              if (error != null) {
                return ErrorStateWidget(
                    errorMessage: error,
                    onRetry: () async {
                      await capsuleProvider.fetchCapsuleById(
                          id: widget.capsuleId);
                    });
              }

              return Skeletonizer(
                enabled: isLoading,
                effect: ShimmerEffect(
                  baseColor:
                      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                  highlightColor:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
                  duration: const Duration(milliseconds: 1200),
                ),
                child: Column(
                  children: [
                    SizedBox(height: isTablet ? 32 : 16),
                    Center(
                      child: Image.asset(
                        'assets/icons/capsule_icon.png',
                        color: isDarkMode ? Colors.white : Colors.black,
                        width: isTablet ? 120 : 80,
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildDetailsCard(capsule: capsule)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  // Builds the details card showing capsule type, status, and total reuses
  Widget _buildDetailsCard({required CapsuleEntity capsule}) {
    final statusColor = getStatusColor(capsule.status);

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
                  'Capsule Type',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  capsule.type,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                StatusContainerWidget(
                    status: capsule.status, color: statusColor),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Total Reuses',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${capsule.reuseCount}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
