import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Supabase'in anlık oturum durumunu dinliyoruz (Girdi mi? Çıktı mı?)
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Kullanıcının oturum verisi var mı diye bakıyoruz
        final session = snapshot.hasData ? snapshot.data!.session : null;

        // Oturum varsa direkt ana sayfaya, yoksa giriş sayfasına atıyoruz
        if (session != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}