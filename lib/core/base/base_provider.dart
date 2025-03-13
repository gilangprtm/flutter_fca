import 'package:flutter/material.dart';

/// A base class for all providers in the application that extends [ChangeNotifier].
///
/// This class provides lifecycle methods that are called from [BaseWidget] during
/// widget lifecycle events. It also provides access to the [BuildContext] from the widget.
abstract class BaseProvider extends ChangeNotifier {
  BuildContext? _context;

  /// Returns the current [BuildContext] associated with this provider.
  BuildContext? get context => _context;

  /// Sets the [BuildContext] associated with this provider.
  ///
  /// This is called by [BaseWidget] during initialization to provide
  /// context-aware operations in the provider.
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Called when the provider is first created.
  ///
  /// Use this method to initialize state or setup listeners.
  /// This is called by [BaseWidget] during [initState].
  void onInit() {
    // To be overridden by subclasses
  }

  /// Called after [onInit] and when the widget is ready.
  ///
  /// Use this method to perform tasks that should happen after the UI is built,
  /// such as fetching initial data.
  void onReady() {
    // To be overridden by subclasses
  }

  /// Called when the provider is about to be disposed.
  ///
  /// Use this method to clean up resources such as listeners or subscriptions.
  /// This is called by [BaseWidget] during [dispose].
  @override
  void dispose() {
    onClose();
    super.dispose();
  }

  /// Called before [dispose] to allow cleanup.
  ///
  /// This method is separated from [dispose] to allow subclasses to perform
  /// custom cleanup without needing to call super.dispose().
  void onClose() {
    // To be overridden by subclasses
  }
}
