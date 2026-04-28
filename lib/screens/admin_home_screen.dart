import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tüm Bağışlar (Admin)'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await Supabase.instance.client.auth.signOut(),
          )
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('donations')
            .stream(primaryKey: ['id'])
            .order('created_at'), 
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final donations = snapshot.data!;
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final item = donations[index];
              return ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.redAccent),
                title: Text(item['title']),
                subtitle: Text("Kullanıcı ID: ${item['user_id']}"),
              );
            },
          );
        },
      ),
    );
  }
}