# Flutter Project with Provider State Management

## Overview

This project is a Flutter application that uses the Provider package for state management. It is designed to demonstrate best practices in managing state in a Flutter app.

## Project Structure

- **lib/**: Contains the main application code.
  - **main.dart**: The entry point of the application.
  - **presentation/**: Contains UI components and screens.
  - **core/**: Contains core functionalities and utilities.
  - **data/**: Contains data models, repositories, and data sources.
- **test/**: Contains test files.
  - **unit/**: Unit tests for repositories, services, etc.
  - **widget/**: Widget tests for UI components.
  - **integration/**: Integration tests for end-to-end flows.
  - **mocks/**: Mock classes for testing.
  - **helpers/**: Helper functions for testing.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd <project-directory>
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

To run the app on an emulator or a physical device, use:

```bash
flutter run
```

### Running Tests

To run all tests:

```bash
flutter test
```

For more information about running specific tests, see the [Testing Guide](test/README.md).

## Documentation

- [Project Structure](docs/project_structure.md): Detailed overview of the project structure within the `lib` directory.
- [Development Roadmap](docs/development_roadmap.md): Checklist of planned improvements and features for the project.
- [Provider Lifecycle](docs/provider_lifecycle.md): Guide to using the Provider Lifecycle Management system.
- [Dependency Injection](docs/dependency_injection.md): Guide to using and managing dependency injection in the project.
- [Services Architecture](docs/services_architecture.md): Explanation of the services architecture and initialization system.
- [Architecture Diagram](docs/architecture_diagram.md): Visual representation of the repository and service pattern.
- [Error Handling & Logging](docs/error_handling.md): Documentation on error handling and logging system.
- [Environment Setup](docs/environment_setup.md): Guide to configuring different environments (development, staging, production).
- [Performance Optimization](docs/performance_optimization.md): Strategies for optimizing application performance.
- [Refactoring](docs/refactoring.md): Documentation of recent refactoring efforts, including service consolidation.
- [Testing Guide](test/README.md): Guide to running and writing tests for the project.

Additional documentation can be found in the `docs` directory.
