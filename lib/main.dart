import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'materi_page.dart';
import 'video_page.dart';
import 'quiz_page.dart';
import 'about_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMS Learning App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;

  // Tiga halaman utama untuk BottomNavigationBar
  final List<Widget> _pages = const [MateriPage(), VideoPage(), QuizPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Data 3 mahasiswa yang akan dikirim ke AboutPage
  final List<Map<String, String>> students = [
    {'name': 'Arif Dewi', 'nim': 'A100123001', 'email': 'arif.dewi@ums.ac.id'},
    {
      'name': 'Budi Santoso',
      'nim': 'A100123002',
      'email': 'budi.santoso@ums.ac.id',
    },
    {
      'name': 'Citra Wijaya',
      'nim': 'A100123003',
      'email': 'citra.wijaya@ums.ac.id',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UMS Learning App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Navigasi ke AboutPage + kirim data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(students: students),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Materi'),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Video',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
        ],
      ),
    );
  }
}
