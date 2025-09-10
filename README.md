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

- A SpaceX mission and rocket explorer app
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

## 📝 Development Tasks

### Phase 1: Foundation (Required)

- [ ] **Task 1.1**: Implement data models for SpaceX entities (Mission, Rocket, Launch, etc.)
- [ ] **Task 1.2**: Create GraphQL queries for SpaceX API
- [ ] **Task 1.3**: Set up repository pattern and use cases
- [ ] **Task 1.4**: Implement Provider state management
- [ ] **Task 1.5**: Create basic navigation structure
- [x] **Task 1.6**: Internationalization (i18n) support (English & French) - ✅ **COMPLETED**

### Phase 2: Core Features (Required)

- [ ] **Task 2.1**: Build Mission Explorer screen with list/grid view
- [ ] **Task 2.2**: Create Rocket Gallery with detailed specifications
- [ ] **Task 2.3**: Implement Launch Tracker for upcoming/past launches
- [ ] **Task 2.4**: Add search and filter functionality
- [ ] **Task 2.5**: Implement pull-to-refresh and pagination

### Phase 3: UI/UX Excellence (Required)

- [ ] **Task 3.1**: Design and implement space-themed UI components
- [ ] **Task 3.2**: Add smooth animations and transitions
- [ ] **Task 3.3**: Implement dark/light theme switching
- [ ] **Task 3.4**: Create responsive design for tablets and phones
- [ ] **Task 3.5**: Add loading states and error handling

### Phase 4: Advanced Features (Bonus)

- [ ] **Task 4.1**: Implement offline data caching
- [ ] **Task 4.2**: Add image gallery with zoom functionality
- [ ] **Task 4.3**: Create interactive rocket 3D models (if possible)
- [ ] **Task 4.4**: Implement push notifications for upcoming launches
- [ ] **Task 4.5**: Add accessibility features and screen reader support

## 🛰️ SpaceX API Integration

### GraphQL Endpoint

```
https://spacex-production.up.railway.app/
```

### Key Data to Implement

- **Missions**: `missions` query
- **Rockets**: `rockets` query
- **Launches**: `launches` query
- **Launchpads**: `launchpads` query
- **Landpads**: `landpads` query

### Sample Queries

```graphql
# Get all missions
query GetMissions {
  missions {
    id
    name
    description
    manufacturers
  }
}

# Get all rockets
query GetRockets {
  rockets {
    id
    name
    type
    active
    cost_per_launch
    success_rate_pct
    first_flight
    country
    company
    height {
      meters
      feet
    }
    diameter {
      meters
      feet
    }
    mass {
      kg
      lb
    }
    flickr_images
    description
  }
}
```

## 🎨 Design System

### Colors

- **Primary**: #1E3A8A (Space Blue)
- **Secondary**: #F59E0B (Rocket Orange)
- **Success**: #10B981 (Mission Green)
- **Error**: #EF4444 (Launch Red)
- **Background**: #0F172A (Dark Space)
- **Surface**: #1E293B (Card Surface)
- **Accent**: #8B5CF6 (Purple Accent)

### Typography

- **Headline**: 24sp, Bold
- **Title**: 20sp, Medium
- **Body**: 16sp, Regular
- **Caption**: 12sp, Regular

### Spacing

- **XS**: 4dp
- **S**: 8dp
- **M**: 16dp
- **L**: 24dp
- **XL**: 32dp

## 📊 Evaluation Criteria

### Technical Implementation (40%)

- Clean architecture implementation
- Proper state management
- GraphQL integration
- Code quality and organization
- Error handling

### UI/UX Design (40%)

- Visual design quality
- User experience flow
- Responsive design
- Animations and transitions
- Accessibility

### Code Quality (20%)

- Code readability
- Documentation
- Git commit history
- Performance optimization
- Testing (if applicable)

## 📤 Submission Guidelines

### What to Submit

1. **Forked Repository**: Your completed implementation
2. **Screenshots**: Key screens and features
3. **Demo Video**: 2-3 minute walkthrough (optional but recommended)
4. **README Update**: Document your implementation approach

### Submission Checklist

- [ ] All required tasks completed
- [ ] App runs without errors
- [ ] Responsive design implemented
- [ ] Clean, well-documented code
- [ ] Updated README with implementation details
- [ ] Screenshots included in repository

### How to Submit

1. Complete all tasks in your forked repository
2. Update the README with your implementation details
3. Add screenshots to a `screenshots/` folder
4. Create a pull request to the original repository
5. Include a brief description of your implementation approach

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Navigation**: GetX
- **API**: GraphQL with graphql_flutter
- **Local Storage**: SharedPreferences
- **UI Components**: Custom widgets + Material Design
- **Internationalization**: Custom i18n implementation (English & French)

## 📚 Learning Resources

### Flutter

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Material Design Guidelines](https://material.io/design)

### State Management

- [Provider Package](https://pub.dev/packages/provider)
- [GetX Package](https://pub.dev/packages/get)

### GraphQL

- [GraphQL Flutter](https://pub.dev/packages/graphql_flutter)
- [GraphQL Documentation](https://graphql.org/learn/)

## 📞 Support

For questions about the challenge, please contact the development team.

---

**Good luck and happy coding! 🚀**
