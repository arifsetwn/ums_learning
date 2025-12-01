import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(home: QuizPage(), debugShowCheckedModeBanner: false),
  );
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> _questions = [];
  final Map<int, int> _userAnswers = {};
  late PageController _pageController;
  int _currentPage = 0;
  late Future<List<Map<String, dynamic>>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questionsFuture = _fetchQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchQuestions() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      {
        'question':
            '1. Program studi apa saja yang ada di FKIP UMS yang berkaitan dengan teknologi?',
        'options': [
          'Pendidikan Teknik Mesin',
          'Pendidikan Teknik Informatika',
          'Pendidikan Akuntansi',
          'Pendidikan Geografi',
        ],
        'answerIndex': 1,
      },
      {
        'question': '2. Apa visi utama dari FKIP UMS?',
        'options': [
          'Menjadi pusat wirausaha',
          'Menjadi pusat pengembangan seni',
          'Menjadi pusat penyiapan tenaga kependidikan yang Islami',
          'Menjadi pusat teknologi nuklir',
        ],
        'answerIndex': 2,
      },
      {
        'question':
            '3. Gelar akademik lulusan S1 Pendidikan Teknik Informatika adalah?',
        'options': ['S.T.', 'S.Kom.', 'S.Pd.', 'S.Pd.T.'],
        'answerIndex': 2,
      },
      {
        'question': '4. Organisasi mahasiswa tingkat fakultas disebut?',
        'options': ['HMP', 'BEM Fakultas', 'UKM', 'IMM'],
        'answerIndex': 1,
      },
      {
        'question':
            '5. Salah satu kompetensi utama yang harus dimiliki calon guru adalah?',
        'options': [
          'Kompetensi Pedagogik',
          'Kompetensi Medis',
          'Kompetensi Agrikultur',
          'Kompetensi Maritim',
        ],
        'answerIndex': 0,
      },
      {
        'question': '6. Program Pendidikan Profesi Guru (PPG) bertujuan untuk?',
        'options': [
          'Mendapatkan gelar S2',
          'Mencetak guru profesional bersertifikat',
          'Magang kerja di pabrik',
          'Liburan semester',
        ],
        'answerIndex': 1,
      },
      {
        'question': '7. Dimana lokasi kampus utama FKIP UMS?',
        'options': ['Kampus 1', 'Kampus 2', 'Kampus 3', 'Kampus 4'],
        'answerIndex': 0,
      },
      {
        'question': '8. Semboyan UMS yang menjadi landasan pendidikan adalah?',
        'options': [
          'Wacana Keilmuan dan Keislaman',
          'Maju Terus Pantang Mundur',
          'Unggul dan Mendunia',
          'Berkarakter dan Berbudaya',
        ],
        'answerIndex': 0,
      },
      {
        'question':
            '9. Laboratorium yang digunakan untuk latihan mengajar disebut?',
        'options': ['Lab Komputer', 'Microteaching', 'Bengkel', 'Greenhouse'],
        'answerIndex': 1,
      },
      {
        'question':
            '10. Tri Dharma Perguruan Tinggi meliputi Pendidikan, Penelitian, dan?',
        'options': [
          'Pengajaran',
          'Pengabdian kepada Masyarakat',
          'Perdagangan',
          'Pariwisata',
        ],
        'answerIndex': 1,
      },
    ];
  }

  void _submitQuiz() {
    if (_userAnswers.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon jawab semua soal sebelum mengumpulkan!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int score = 0;
    _questions.asMap().forEach((index, question) {
      if (_userAnswers[index] == question['answerIndex']) {
        score++;
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hasil Kuis'),
        content: Text('Skor Anda: $score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _userAnswers.clear();
                _currentPage = 0;
                _pageController.jumpToPage(0);
              });
            },
            child: const Text('Ulangi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuis FKIP UMS')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error memuat soal: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            if (_questions.isEmpty) _questions = snapshot.data!;

            return Column(
              children: [
                // Indikator Progress
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Soal ${_currentPage + 1} dari ${_questions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // PageView untuk menampilkan 1 soal per halaman
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  question['question'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...List.generate(question['options'].length, (
                                optIndex,
                              ) {
                                final bool selected =
                                    _userAnswers[index] == optIndex;
                                return ListTile(
                                  title: Text(question['options'][optIndex]),
                                  leading: Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _userAnswers[index] = optIndex;
                                    });
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Tombol Next dan Back
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _currentPage > 0
                            ? () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('BACK'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _currentPage < _questions.length - 1
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : _submitQuiz,
                        icon: Icon(
                          _currentPage < _questions.length - 1
                              ? Icons.arrow_forward
                              : Icons.check,
                        ),
                        label: Text(
                          _currentPage < _questions.length - 1
                              ? 'NEXT'
                              : 'SUBMIT',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
