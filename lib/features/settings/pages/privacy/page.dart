import 'package:flutter/material.dart';
import 'package:kasirsuper/core/core.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String routeName = '/settings/privacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kebijakan Privasi')),
      body: ListView(
        padding: const EdgeInsets.all(Dimens.defaultSize),
        children: const [
          Text(
            'Kebijakan Privasi\n\n1. Pengumpulan Informasi\nKami mengumpulkan informasi pribadi seperti nama, alamat email, dan nomor telepon ketika Anda mendaftar atau menggunakan layanan kami.\n\n2. Penggunaan Informasi\nInformasi yang kami kumpulkan digunakan untuk meningkatkan layanan kami, mengirim pembaruan, dan memberikan dukungan pelanggan.\n\n3. Keamanan Data\nKami berkomitmen untuk melindungi informasi pribadi Anda dengan langkah-langkah keamanan yang sesuai.\n\n4. Pembagian Informasi\nKami tidak akan membagikan informasi pribadi Anda kepada pihak ketiga tanpa izin Anda, kecuali jika diwajibkan oleh hukum.\n\n5. Perubahan Kebijakan\nKami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Perubahan akan diumumkan di halaman ini.',
          ),
        ],
      ),
    );
  }
}