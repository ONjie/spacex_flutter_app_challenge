import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/presentation/providers/capsule_provider.dart';
import 'package:spacex_flutter_app/presentation/widgets/capsule_screen_widgets/capsules_list_view_widget.dart';
import '../widgets/error_state_widget.dart';


// This screen displays a list of SpaceX Dragon Capsules.
/// Supports pagination, pull-to-refresh, loading shimmer, 
/// and error handling.
class CapsulesScreen extends StatefulWidget {
  const CapsulesScreen({super.key});

  @override
  State<CapsulesScreen> createState() => _CapsulesScreenState();
}

class _CapsulesScreenState extends State<CapsulesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial capsules when the screen is loaded
    Future.microtask(() async {
      if (!mounted) return;
      Provider.of<CapsuleProvider>(context, listen: false)
          .fetchCapsulesByPagination();
    });

     // Add listener to handle infinite scroll (load more capsules)
    _scrollController.addListener(() {
      final provider = context.read<CapsuleProvider>();
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        provider.fetchCapsulesByPagination();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = screenWidth > 600 ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          child: Consumer<CapsuleProvider>(
            builder: (context, capsuleProvider, child) {
              final capsules = capsuleProvider.paginatedCapsules;
              final error = capsuleProvider.error;
              final isLoading = capsuleProvider.isLoading;

              if (error != null && capsules.isEmpty) {
                return ErrorStateWidget(
                  errorMessage: error,
                  onRetry: () async => await capsuleProvider.fetchCapsules(),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: RefreshIndicator(
                  onRefresh: () async => capsuleProvider.refreshCapsules(),
                  child: Skeletonizer(
                    enabled: isLoading,
                    effect: ShimmerEffect(
                      baseColor: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      highlightColor: isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade100,
                      duration: const Duration(milliseconds: 1200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenWidth > 600 ? 24 : 16),
                        Text(
                          'Dragon Capsules',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth > 600 ? 40 : 28,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Reusable spacecraft fleet",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth > 600 ? 20 : 16,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: CapsulesListViewWidget(
                            capsules: isLoading
                                ? List.generate(
                                    7, (index) => CapsuleEntity.capsuledummy)
                                : capsules, // Show dummy capsules while loading
                            scrollController: _scrollController,
                            isFetchingMore: capsuleProvider.isFetchingMore,
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
      ),
    );
  }
}
