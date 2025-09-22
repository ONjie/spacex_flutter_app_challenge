import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spacex_flutter_app/presentation/widgets/error_state_widget.dart';

import '../providers/launch_provider.dart';
import '../widgets/launches_screen_widgets/launches_list_view_widget.dart';


// Screen that allows the user to search and filter SpaceX launches.
// Supports debounced search, filtering by upcoming launches, and displays results dynamically.
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
     // Fetch initial list of launches when the screen is first loaded
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<LaunchProvider>(context, listen: false).fetchLaunches();
    });
  }

  // Debounces search input to avoid excessive calls when user types
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      context.read<LaunchProvider>().setSearchQuery(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context: context),
      body: _buildBody(context: context),
    );
  }

  AppBar _buildAppBar({required BuildContext context}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Search Launches',
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

  Widget _buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
          child: Consumer<LaunchProvider>(
            builder: (context, launchProvider, child) {
              final filteredLaunches = launchProvider.filteredLaunches;
              final error = launchProvider.error;

              // Show error widget if fetching launches failed
              if (error != null) {
                return ErrorStateWidget(
                    errorMessage: error,
                    onRetry: () async {
                      await launchProvider.fetchLaunches();
                    });
              }

              return Column(
                children: [
                    // Search input field and filter dropdown
                  _buildSearchAndFilter(
                    isDarkMode: isDarkMode,
                    launchProvider: launchProvider,
                  ),
                  const SizedBox(height: 20),
                   // Display filtered launches or "No launches found" if empty
                  Expanded(
                    child: filteredLaunches.isEmpty
                        ? const Center(
                            child: Text(
                              'No launches found',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : LaunchesListViewWidget(
                            launches: filteredLaunches,
                            isFetchingMore: false,
                            scrollController: ScrollController(),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  // Builds the search input field and upcoming filter dropdown
  Widget _buildSearchAndFilter({
    required bool isDarkMode,
    required LaunchProvider launchProvider,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search launches...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor:
                  isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        const SizedBox(width: 12),

        // Upcoming filter dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
            ),
          ),
          child: DropdownButton<bool>(
            value: launchProvider.filterUpcoming,
            hint: const Text('Upcoming'),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (upcoming) =>
                launchProvider.setFilter(upcoming: upcoming),
          ),
        ),
        if (launchProvider.filterUpcoming != null ||
            launchProvider.hasSearchQuery)
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Clear filters',
            onPressed: () {
              launchProvider.resetFilters();
              _searchController.clear();
            },
          ),
      ],
    );
  }
}
