import 'package:flutter/material.dart';
import '../../../core/base/base_widget.dart';
import '../../../core/mahas/widget/error_widgets.dart';
import '../../providers/home_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeProvider>(
      onModelReady: (model) {
        model.onReady();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Screen'),
            actions: [
              IconButton(
                icon: const Icon(Icons.error_outline),
                onPressed: () {
                  // Demonstrate error dialog usage
                  context.showErrorDialog(
                    title: 'Example Error',
                    message:
                        'This is an example of the error dialog component.',
                    onRetry: () {
                      // Handle retry action
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Retry action triggered')),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to Flutter Provider Kit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: model.incrementCount,
                      child: const Text('Trigger Network Call'),
                    ),
                    const SizedBox(height: 24),

                    // Error widget examples
                    const Text(
                      'Error Widget Examples:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ErrorPlaceholderWidget(
                      icon: Icons.cloud_off,
                      message: 'No internet connection',
                    ),

                    const SizedBox(height: 16),

                    ErrorWithActionWidget(
                      title: 'Data could not be loaded',
                      message: 'There was an issue loading your data',
                      actionText: 'Try Again',
                      onAction: () {
                        model.fetchInitialData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Refreshing data...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/log-viewer');
            },
            tooltip: 'Log Viewer',
            child: const Icon(Icons.list),
          ),
        );
      },
    );
  }
}
