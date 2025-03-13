# Project Structure Documentation

This document provides a comprehensive overview of the Flutter Provider Kit project structure, organization, and architecture.

## Overview

The project follows a clean architecture approach with clear separation of concerns to ensure maintainability, testability, and scalability.

## Directory Structure

Below is the hierarchical structure of the `lib/` directory:

```
lib/
├── core/
│   ├── di/
│   │   └── service_locator.dart         # Dependency injection setup using GetIt
│   ├── env/
│   │   └── app_environment.dart         # Environment configuration (dev, staging, prod)
│   ├── helper/
│   │   └── dialog_helper.dart           # Helper functions for dialogs
│   ├── mahas/                           # Core functionality and services
│       ├── mahas_config.dart            # Configuration for the Mahas framework
│       ├── mahas_service.dart           # Central service orchestration
│       ├── models/
│       │   └── api_result_model.dart    # Model for API responses
│       ├── pages/
│       │   └── log_viewer_page.dart     # UI for viewing application logs
│       ├── services/
│       │   ├── api_service.dart         # Service for API communication with caching
│       │   ├── error_handler_service.dart # Global error handling
│       │   ├── firebase_service.dart    # Firebase integration
│       │   ├── logger_service.dart      # Logging functionality
│       │   ├── performance_service.dart # Performance tracking and optimization
│       │   └── storage_service.dart     # Local storage functionality
│       └── widget/
│           └── error_widgets.dart       # UI components for error states
│
├── data/
│   └── datasource/
│       ├── models/                      # Data models for the application
│       └── network/
│           ├── base_repository.dart     # Base class for repositories
│           ├── db/
│           │   ├── dio_service.dart     # API communication using Dio
│           │   └── http_api.dart        # API communication using Http package
│           ├── repository/
│           │   └── user_repository.dart # Repository for user-related operations
│           └── service/
│               ├── home_service.dart    # Service for home screen data
│               └── informasi_absensi_service.dart # Service for attendance information
│
├── presentation/
    ├── pages/                          # Application screens/pages
    ├── providers/                      # State management using Provider
    │   └── base_provider.dart          # Base class for providers
    └── widgets/                        # Reusable UI components
```

## Key Components

### Service Locator (Dependency Injection)

The project uses GetIt for dependency injection, configured in `lib/core/di/service_locator.dart`.
This provides a clean way to access services from anywhere in the application.

### Services

The application has two types of services:

1. **Core Services (in `lib/core/mahas/services/`)**:

   - `logger_service.dart`: Handles logging with different levels
   - `error_handler_service.dart`: Global error handling and reporting
   - `api_service.dart`: Handles API requests with caching strategies
   - `performance_service.dart`: Tracks and analyzes application performance
   - `firebase_service.dart`: Firebase integration
   - `storage_service.dart`: Local data persistence

2. **Network Services (in `lib/data/datasource/network/`)**:
   - `dio_service.dart`: HTTP client using Dio package
   - `http_api.dart`: HTTP client using Http package
   - Service implementations for specific features (e.g., `home_service.dart`)

### Repositories

Repositories (in `lib/data/datasource/network/repository/`) connect the data layer to the business logic,
abstracting the data source implementation details.

### Providers

The application uses the Provider pattern for state management, with a `BaseProvider` class
that contains common functionality for all providers.

## Architecture

The project follows a clean architecture approach with the following layers:

1. **Presentation Layer**: UI components, pages, and state management (providers)
2. **Domain Layer**: Business logic and use cases
3. **Data Layer**: Data sources, repositories, and models

### Benefits of this Architecture:

1. **Separation of Concerns**: Each component has a single responsibility
2. **Testability**: Easy to test individual components in isolation
3. **Maintainability**: Changes in one layer don't affect others
4. **Reusability**: Components can be reused across the application
5. **Scalability**: Easy to add new features or modify existing ones

## Best Practices

The code follows these best practices:

1. **Dependency Injection**: Using GetIt to provide dependencies
2. **Singleton Pattern**: For services that need a single instance
3. **Error Handling**: Centralized error handling with the ErrorHandlerService
4. **Logging**: Comprehensive logging with different levels
5. **Performance Tracking**: Monitoring and optimizing application performance
6. **Environment Configuration**: Different settings for development, staging, and production

## How to Extend the Project

When adding new features:

1. Create appropriate models in `data/datasource/models/`
2. Implement repository interfaces in `data/datasource/network/repository/`
3. Create service implementations in `data/datasource/network/service/`
4. Register new services in the service locator
5. Create providers for state management
6. Implement UI components and pages
