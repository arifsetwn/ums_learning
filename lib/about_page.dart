import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final List<Map<String, String>> students;

  const AboutPage({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    // AppBar otomatis menampilkan tombol "back" (Navigator.pop)
    return Scaffold(
      appBar: AppBar(title: const Text('About Developer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Mahasiswa Pembuat Aplikasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mahasiswa ${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Nama : ${student['name']}'),
                          Text('NIM  : ${student['nim']}'),
                          Text('Email: ${student['email']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
