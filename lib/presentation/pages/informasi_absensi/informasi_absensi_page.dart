import 'package:flutter/material.dart';

import '../../../core/base/provider_widget.dart';
import '../../providers/informasi_absensi_provider.dart';

class InformasiAbsensiPage extends StatelessWidget {
  const InformasiAbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderPage<InformasiAbsensiProvider>(
      builder: (context, provider) => Scaffold(
        appBar: AppBar(
          title: const Text("Informasi Absensi"),
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
            ],
          ),
        ),
      ),
    );
  }
}
