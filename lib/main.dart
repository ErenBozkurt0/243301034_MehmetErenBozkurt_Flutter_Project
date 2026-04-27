import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart'; // Eklediğimiz ekranı tanıttık
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ymrbnaotloqfooruuolk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InltcmJuYW90bG9xZm9vcnV1b2xrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMzUzNDIsImV4cCI6MjA5MjcxMTM0Mn0.H5HjoKRxXdqoqcU2xarZinidcFA_VFzCX6MUPpR8S-Y',
  );

  runApp(const ErzakBagisApp());
}

class ErzakBagisApp extends StatelessWidget {
  const ErzakBagisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erzak Bağış',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AuthGate(), // Artık uygulama ilk olarak kapıdaki güvenliğe (AuthGate) soracak
    );
  }
}