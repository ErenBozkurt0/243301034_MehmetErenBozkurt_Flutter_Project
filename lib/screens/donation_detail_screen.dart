import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils.dart'; // Log fonksiyonu için

class DonationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> donation; // Tıklanan bağışın verilerini alıyoruz

  const DonationDetailScreen({super.key, required this.donation});

  @override
  State<DonationDetailScreen> createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Gelen verileri kutucuklara dolduruyoruz
    _titleController = TextEditingController(text: widget.donation['title']);
    _descController = TextEditingController(text: widget.donation['description']);
  }

  // GÜNCELLEME İŞLEMİ
  Future<void> _bagisGuncelle() async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.from('donations').update({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
      }).eq('id', widget.donation['id']);

      // Log atıyoruz
      await logIslemi('GUNCELLEME', '${widget.donation['title']} -> ${_titleController.text} olarak güncellendi.');

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağış başarıyla güncellendi.')));
      }
    } catch (e) {
      print('Hata: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // SİLME İŞLEMİ
  Future<void> _bagisSil() async {
    // Önce kullanıcıya "Emin misin?" diye soralım
    bool eminMi = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bağışı Sil'),
        content: const Text('Bu bağışı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (eminMi) {
      setState(() => _isLoading = true);
      try {
        await Supabase.instance.client.from('donations').delete().eq('id', widget.donation['id']);

        // Log atıyoruz
        await logIslemi('SILME', '${widget.donation['title']} adlı bağış silindi.');

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bağış silindi.')));
        }
      } catch (e) {
        print('Hata: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bağış Detayı'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _isLoading ? null : _bagisSil,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Bağış Başlığı', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Açıklama', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _bagisGuncelle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Değişiklikleri Kaydet', style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}