import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const KidsGameApp());
}

class KidsGameApp extends StatelessWidget {
  const KidsGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لعبة الحروف والأرقام',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const GameModeScreen(),
    );
  }
}

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ألعاب الأطفال التعليمية'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'اختر قسم التعلم',
                style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen(isNumbers: false)),
                  );
                },
                icon: const Icon(Icons.abc, size: 36),
                label: const Text('لعبة الحروف العربية'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen(isNumbers: true)),
                  );
                },
                icon: const Icon(Icons.looks_one, size: 36),
                label: const Text('لعبة الأرقام'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final bool isNumbers;
  const GameScreen({super.key, required this.isNumbers});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  late List<String> items;
  late String currentTarget;
  late List<String> options;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    items = widget.isNumbers 
        ? ['١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩', '١٠']
        : ['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي'];
    generateNewQuestion();
  }

  void generateNewQuestion() {
    items.shuffle(random);
    currentTarget = items[0];
    
    // اختيار 3 خيارات خاطئة مع الخيار الصحيح
    List<String> wrongOptions = items.where((item) => item != currentTarget).toList();
    wrongOptions.shuffle(random);
    
    options = [currentTarget, wrongOptions[0], wrongOptions[1], wrongOptions[2]];
    options.shuffle(random);
    setState(() {});
  }

  void checkAnswer(String selected) {
    bool isCorrect = (selected == currentTarget);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? 'أحسنت بطل! 🎉' : 'خطأ، حاول مرة أخرى ❌', textAlign: TextAlign.center),
        content: Text(
          isCorrect ? 'إجابة صحيحة وصوت رائع!' : 'الحرف المطلوب كان: $currentTarget', 
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (isCorrect) score += 10;
                  generateNewQuestion();
                });
              },
              child: const Text('السؤال التالي'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNumbers ? 'لعبة الأرقام' : 'لعبة الحروف'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 36),
                const SizedBox(width: 8),
                Text(
                  'النقاط: $score',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'اختر الحرف أو الرقم المطلوب:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo, width: 3),
              ),
              child: Text(
                currentTarget,
                style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
            ),
            const SizedBox(height: 40),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                buildOptionCard(options[0], Colors.pinkAccent),
                buildOptionCard(options[1], Colors.orangeAccent),
                buildOptionCard(options[2], Colors.greenAccent),
                buildOptionCard(options[3], Colors.purpleAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionCard(String text, Color color) {
    return GestureDetector(
      onTap: () => checkAnswer(text),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
