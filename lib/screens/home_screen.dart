import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Supabase'den çıkış yapma komutu
              await Supabase.instance.client.auth.signOut();
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Giriş Başarılı! Erzak Bağış Sistemine Hoş Geldin.'),
      ),
    );
  }
}