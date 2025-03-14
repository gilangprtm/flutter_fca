import 'package:flutter/material.dart';

import '../../../core/base/provider_widget.dart';
import '../../../core/mahas/widget/mahas_button.dart';
import '../../../core/utils/mahas.dart';
import '../../providers/home_provider.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderPage<HomeProvider>(
      createProvider: () => HomeProvider(),
      builder: (context, provider) => Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Count: ${provider.count}',
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.incrementCount,
                child: const Text('Increment Count'),
              ),
              const SizedBox(height: 32),
              MahasButton(
                text: 'Mahas Widget Showcase',
                onPressed: () {
                  Mahas.routeTo(AppRoutes.mahasShowcase);
                },
              ),
              const SizedBox(height: 32),
              MahasButton(
                text: 'Page Example',
                onPressed: () {
                  Mahas.routeTo(AppRoutes.informasiAbsensi);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
