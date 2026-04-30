import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_donation_screen.dart';
import 'donation_detail_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bağışlarım'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async =>
                await Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('donations')
            .stream(primaryKey: ['id'])
            .eq('user_id', userId)
            .order('created_at'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final donations = snapshot.data!;
          if (donations.isEmpty) {
            return const Center(child: Text('Henüz bağış yapmadınız.'));
          }
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final item = donations[index];
              // ... ListView.builder içindeki itemBuilder kısmı:
              return ListTile(
                leading: const Icon(Icons.inventory_2, color: Colors.green),
                title: Text(item['title']),
                subtitle: Text(item['description'] ?? ''),
                trailing: const Icon(
                  Icons.chevron_right,
                ), // Sağa ok işareti ekleyelim
                onTap: () {
                  // Tıklandığında detay sayfasına gönderiyoruz
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DonationDetailScreen(donation: item),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddDonationScreen()),
        ),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
