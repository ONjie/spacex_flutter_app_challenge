# 🚀 SpaceX Flutter App - UI/UX Development Challenge

A Flutter application development challenge focused on creating a beautiful UI/UX experience for exploring SpaceX data. This project serves as a base structure for applicants to implement and showcase their Flutter development skills.

## 📋 Table of Contents

- [Challenge Overview](#challenge-overview)
- [Project Setup](#project-setup)
- [Architecture](#architecture)
- [Development Tasks](#development-tasks)
- [SpaceX API Integration](#spacex-api-integration)
- [Design System](#design-system)
- [Evaluation Criteria](#evaluation-criteria)
- [Submission Guidelines](#submission-guidelines)

## 🎯 Challenge Overview

This repository contains a base Flutter project structure that applicants need to **fork** and complete. The goal is to build a modern, responsive SpaceX data explorer app with exceptional UI/UX design.

### What You'll Build

- A SpaceX capsule and rocket explorer app
- Beautiful, space-themed UI with smooth animations
- GraphQL integration with SpaceX API
- Clean architecture implementation
- Responsive design for all screen sizes

## 🚀 Project Setup

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Git

### Getting Started

1. **Fork this repository** (do not clone)
2. Clone your forked repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/flutter_ui_ux_test_project.git
   cd flutter_ui_ux_test_project
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the project:
   ```bash
   flutter run
   ```

## 🏗️ Architecture

The project follows Clean Architecture principles. You'll need to implement:

```
lib/
├── core/                    # Core utilities and configurations
│   ├── network/            # GraphQL client setup
│   ├── utils/              # Theme, colors, constants
│   └── constants/          # App constants
├── data/                   # Data layer (TO IMPLEMENT)
│   ├── models/             # Data models for SpaceX data
│   ├── queries/            # GraphQL queries
│   └── repositories/       # Data repositories
├── domain/                 # Domain layer (TO IMPLEMENT)
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── use_cases/          # Business logic
└── presentation/           # Presentation layer (TO IMPLEMENT)
    ├── providers/          # State management
    ├── screens/            # UI screens
    ├── widgets/            # Reusable widgets
    └── utils/              # UI utilities
```

## Detailed Implementation Approach

### Project Setup & Architecture
Clean Architecture was followed by splitting the project into:
Domain Layer → Entities & Use Cases (business logic)
Data Layer → Repositories & API services
Presentation Layer → UI screens, widgets, and Providers
Used Provider for state management across the app, keeping business logic separate from UI.

### Data Handling
Repository Pattern implemented via SpaceXRepository interface.
Either<Failure, T> was used to handle success and failure responses consistently.
Use Cases were created for each feature:
FetchRocketsUseCase, FetchCapsulesByPaginationUseCase, FetchLaunchByIdUseCase, etc.
NetworkInfo class integrated with internet_connection_checker to detect connectivity and avoid unnecessary API calls.

### UI Design & Theming
Built with Flutter's Material Design principles.
Implemented light and dark mode support using Theme.of(context) to dynamically adjust colors.
Consistent typography and spacing applied across screens for a professional look.
Created reusable widgets for:
Error Handling: ErrorStateWidget
Status Display: StatusContainerWidget
Cards: description, physical specifications, performance metrics

### Skeleton Loading & Shimmer
Integrated Skeletonizer with a smooth Shimmer effect for:
Rockets list
Rocket details
Launches list
Capsules list
This enhances perceived performance and provides a polished user experience.


### Pagination & Infinite Scroll
Implemented offset-based pagination in LaunchProvider and CapsuleProvider.
Implemented a ScrollController to detect when the user reaches the bottom and trigger:
if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
  provider.fetchLaunchesByPagination();
}
Ensures smooth infinite scrolling without blocking the UI.


### Search & Filters
Implemented debounced search to minimize unnecessary state updates:
Timer? _debounce;
_debounce = Timer(const Duration(milliseconds: 100), () {
  launchProvider.setSearchQuery(query: query);
});
Added dropdown filter for "upcoming" launches.
Clear filters button resets both search query and filter state.


### Error Handling & Retry
Centralized error handling using custom Failure classes (e.g., GraphQLFailure).
Displayed human-friendly messages in ErrorStateWidget.
Included retry buttons to re-fetch data when an error occurs.


### Responsive UI
Adjusted font sizes and padding based on screen width (e.g., tablets vs phones).
Used Expanded and AspectRatio widgets for scalable layouts.


### Utility Functions
Created formatting helpers for consistent display:
formatCurrency() – Converts cost per launch into compact currency (e.g., $50M).
formatDate() – Standardizes date display.
formatLaunchDate() – Converts UTC date to local time with human-readable format.
getStatusColor() – Maps launch/rocket status to a color for badges.


### Testing & Verification
Verified GraphQL calls for all use cases.
Tested pagination, refresh indicators, and error states.
Verified UI in both dark mode and light mode.
Checked responsiveness on multiple device sizes.
Implemented Unit test for Repositories, Use cases and providers

### Documentation & Screenshots
Updated README.md with feature list, installation steps, and screenshots.
Added screenshots to screenshots/ folder:
Home, Rockets, Rocket Details, Capsules, Launches, Launch Details, Search Results