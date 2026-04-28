import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_home_screen.dart';
import 'user_home_screen.dart';

class RoleChecker extends StatefulWidget {
  const RoleChecker({super.key});

  @override
  State<RoleChecker> createState() => _RoleCheckerState();
}

class _RoleCheckerState extends State<RoleChecker> {

  Future<String> _getUserRole() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 'user'; 

    final response = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();

    return response['role'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final role = snapshot.data;
        
        if (role == 'admin') {
          return const AdminHomeScreen();
        } else {
          return const UserHomeScreen();
        }
      },
    );
  }
}