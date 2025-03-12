
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  
  import '../../providers/informasi_absensi_provider.dart';
  
  class InformasiAbsensiPage extends StatelessWidget {
    const InformasiAbsensiPage({super.key});
  
    @override
    Widget build(BuildContext context) {
      final provider = Provider.of<InformasiAbsensiProvider>(context);
      provider.context = context;
  
      return Scaffold(
        appBar: AppBar(
          title: const Text("InformasiAbsensi Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Count: ${provider.count}', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.incrementCount,
                child: const Text('Increment Count'),
              ),
            ],
          ),
        ),
      );
    }
  }
    