import 'package:flutter/material.dart';

void main() {
  runApp(const KidsGameApp());
}

class KidsGameApp extends StatelessWidget {
  const KidsGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لعبة الأطفال التعليمية',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameHomePage(),
    );
  }
}

class GameHomePage extends StatefulWidget {
  const GameHomePage({Key? key}) : super(key: key);

  @override
  State<GameHomePage> createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  int score = 0;

  void checkAnswer(String selected) {
    if (selected == 'correct') {
      setState(() {
        score += 10;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('إجابة صحيحة! 🎉'),
          content: const Text('أحسنت يا بطل!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('محاولة أخرى 💪'),
          content: const Text('حاول مرة أخرى يا بطل!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/kids.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ألعاب الأطفال التعليمية',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'النقاط: $score',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: () => checkAnswer('correct'),
                  child: const Text(
                    'اضغط هنا للاختبار',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
