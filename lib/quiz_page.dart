import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('1. Program studi apa saja yang ada di FKIP UMS?'),
        Text('2. Apa visi dan misi FKIP UMS?'),
        Text('3. Bagaimana peran FKIP dalam mencetak calon guru profesional?'),
      ],
    );
  }
}
