import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> logIslemi(String islemTuru, String detay) async {
  try {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return; 

    await Supabase.instance.client.from('logs').insert({
      'user_id': user.id,
      'action_type': islemTuru,
      'details': detay,
    });
  } catch (e) {
    print('Log atılamadı: $e'); 
  }
}