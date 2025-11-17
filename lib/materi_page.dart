import 'package:flutter/material.dart';

class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tambahan Image
          Center(
            child: Image.network(
              'https://news.ums.ac.id/id/wp-content/uploads/sites/2/2022/12/Resmi_Logo_UMS_Color_FullText-1-768x300.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Universitas Muhammadiyah Surakarta (UMS)',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'UMS adalah salah satu perguruan tinggi Muhammadiyah yang '
            'berlokasi di Surakarta. Kampus ini memiliki berbagai program '
            'studi dan fasilitas pendukung pembelajaran yang lengkap.',
          ),
        ],
      ),
    );
  }
}
