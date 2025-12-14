import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    try {
      // Timeout 5 detik untuk menghindari loading terlalu lama
      final snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .get()
          .timeout(const Duration(seconds: 5));

      if (snapshot.docs.isEmpty) {
        // Jika collection kosong, throw error
        throw Exception('Data soal tidak ditemukan di server');
      }

      return snapshot.docs.map((doc) {
        return {
          'question': doc['question'],
          'options': List<String>.from(doc['options']),
          'answerIndex': doc['answerIndex'],
        };
      }).toList();
    } on TimeoutException {
      throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
    } catch (e) {
      throw Exception('Server Error: Gagal memuat soal dari server.');
    }
  }

  void _retryFetch() {
    setState(() {
      _questionsFuture = _fetchQuestions();
    });
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat soal dari server...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Server Error',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}'.replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retryFetch,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
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
