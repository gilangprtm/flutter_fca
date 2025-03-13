import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../di/service_locator.dart';
import 'base_provider.dart';

/// A base widget that handles the creation and cleanup of a provider.
///
/// This widget creates a provider of type T using [ChangeNotifierProvider],
/// and handles the lifecycle of the provider including initialization and cleanup.
class BaseWidget<T extends BaseProvider> extends StatefulWidget {
  /// Builder function that builds the widget tree using the provided model.
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  /// Optional child widget that is passed to the builder function.
  final Widget? child;

  /// Optional callback that is called when the model is ready (after initialization).
  final Function(T)? onModelReady;

  /// Flag to indicate whether the provider should be created from the service locator.
  final bool useServiceLocator;

  /// Optional provider to use instead of creating a new one.
  final T? provider;

  /// Creates a BaseWidget.
  ///
  /// If [useServiceLocator] is true (default), the provider will be retrieved from the service locator.
  /// Otherwise, [provider] must be provided.
  const BaseWidget({
    super.key,
    required this.builder,
    this.child,
    this.onModelReady,
    this.useServiceLocator = true,
    this.provider,
  }) : assert(useServiceLocator || provider != null);

  @override
  State<BaseWidget<T>> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends BaseProvider> extends State<BaseWidget<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.useServiceLocator ? serviceLocator<T>() : widget.provider!;

    // Set the BuildContext to enable context-aware operations in the provider
    model.setContext(context);

    // Initialize the model
    model.onInit();

    // Call onModelReady if provided
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
  }

  @override
  void dispose() {
    // Call onClose to clean up resources when the widget is removed
    model.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
