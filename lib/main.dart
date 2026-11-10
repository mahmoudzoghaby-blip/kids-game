import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
      title: 'لعبة الأطفال التعليمية',
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'اختر قسم التعلم',
                    style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      minimumSize: const Size(280, 55),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen(gameType: GameType.arabicLetters)),
                      );
                    },
                    child: const Text('لعبة الحروف العربية'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      minimumSize: const Size(280, 55),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen(gameType: GameType.englishLetters)),
                      );
                    },
                    child: const Text('لعبة الحروف الإنجليزية'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      minimumSize: const Size(280, 55),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen(gameType: GameType.numbers)),
                      );
                    },
                    child: const Text('لعبة الأرقام (من 1 إلى 50)'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      minimumSize: const Size(280, 55),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen(gameType: GameType.animals)),
                      );
                    },
                    child: const Text('لعبة الحيوانات'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum GameType { arabicLetters, englishLetters, numbers, animals }

class AnimalItem {
  final String name;
  final String emoji;
  const AnimalItem(this.name, this.emoji);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimalItem && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class GameScreen extends StatefulWidget {
  final GameType gameType;
  const GameScreen({super.key, required this.gameType});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  
  late List<dynamic> items;
  late dynamic currentTarget;
  late List<dynamic> options;
  
  final Random random = Random();
  final FlutterTts flutterTts = FlutterTts();

  final List<AnimalItem> animalsList = [
    const AnimalItem('أسد', '🦁'),
    const AnimalItem('نمر', '🐅'),
    const AnimalItem('فيل', '🐘'),
    const AnimalItem('زرافة', '🦒'),
    const AnimalItem('قرد', '🐒'),
    const AnimalItem('دب', '🐻'),
    const AnimalItem('حصان', '🐎'),
    const AnimalItem('بقرة', '🐄'),
    const AnimalItem('خروف', '🐑'),
    const AnimalItem('قطة', '🐈'),
    const AnimalItem('كلب', '🐕'),
    const AnimalItem('بطة', '🦆'),
    const AnimalItem('أرنب', '🐰'),
    const AnimalItem('ثعلب', '🦊'),
    const AnimalItem('ذئب', '🐺'),
    const AnimalItem('باندا', '🐼'),
    const AnimalItem('كوالا', '🐨'),
    const AnimalItem('خنزير', '🐖'),
    const AnimalItem('ماعز', '🐐'),
    const AnimalItem('جمال', '🐪'),
    const AnimalItem('كنغر', '🦘'),
    const AnimalItem('غزال', '🦌'),
    const AnimalItem('حمار وحشي', '🦓'),
    const AnimalItem('سلحفاة', '🐢'),
    const AnimalItem('ثعبان', '🐍'),
    const AnimalItem('بطريق', '🐧'),
    const AnimalItem('بومة', '🦉'),
    const AnimalItem('نسر', '🦅'),
  ];

  @override
  void initState() {
    super.initState();
    initTts();
    
    if (widget.gameType == GameType.numbers) {
      items = List.generate(50, (index) => (index + 1).toString());
    } else if (widget.gameType == GameType.arabicLetters) {
      items = ['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي'];
    } else if (widget.gameType == GameType.englishLetters) {
      items = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    } else {
      items = List.from(animalsList);
    }
    
    generateNewQuestion();
  }

  void initTts() async {
    if (widget.gameType == GameType.englishLetters) {
      await flutterTts.setLanguage("en-US");
    } else {
      await flutterTts.setLanguage("ar-SA");
    }
    await flutterTts.setSpeechRate(0.4);
  }

  void speak(String text, {bool isEnglish = false}) async {
    if (isEnglish) {
      await flutterTts.setLanguage("en-US");
    } else {
      await flutterTts.setLanguage("ar-SA");
    }
    await flutterTts.speak(text);
  }

  void generateNewQuestion() {
    items.shuffle(random);
    currentTarget = items[0];
    
    List<dynamic> wrongOptions = items.where((item) => item != currentTarget).toList();
    wrongOptions.shuffle(random);
    
    options = [currentTarget, wrongOptions[0], wrongOptions[1], wrongOptions[2]];
    options.shuffle(random);
    
    setState(() {});
    
    if (widget.gameType == GameType.animals) {
      speak("أين حيوان ${currentTarget.name}");
    } else if (widget.gameType == GameType.numbers) {
      speak("أين الرقم $currentTarget");
    } else if (widget.gameType == GameType.englishLetters) {
      speak("Where is letter");
      speak(currentTarget, isEnglish: true);
    } else {
      speak("أين حرف $currentTarget");
    }
  }

  void checkAnswer(dynamic selected) {
    bool isCorrect = (selected == currentTarget);
    
    if (isCorrect) {
      speak("ممتاز! إجابة صحيحة");
    } else {
      speak("حاول مرة أخرى");
    }

    String correctText = widget.gameType == GameType.animals ? currentTarget.name : currentTarget;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? 'أحسنت بطل! 🎉' : 'خطأ، حاول مرة أخرى ❌', textAlign: TextAlign.center),
        content: Text(
          isCorrect ? 'إجابة صحيحة!' : 'الخيار المطلوب كان: $correctText', 
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

  String getTitle() {
    if (widget.gameType == GameType.numbers) return 'لعبة الأرقام (1-50)';
    if (widget.gameType == GameType.arabicLetters) return 'لعبة الحروف العربية';
    if (widget.gameType == GameType.englishLetters) return 'لعبة الحروف الإنجليزية';
    return 'لعبة الحيوانات';
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = widget.gameType == GameType.englishLetters;

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 36),
                    const SizedBox(width: 8),
                    Text(
                      '$score',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 36, color: Colors.indigo),
                  onPressed: () {
                    if (widget.gameType == GameType.animals) {
                      speak(currentTarget.name);
                    } else {
                      speak(currentTarget, isEnglish: isEnglish);
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.gameType == GameType.animals ? 'اختر صورة الحيوان الصحيح:' : 'اختر المطلوب:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
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
                widget.gameType == GameType.animals ? currentTarget.emoji : currentTarget,
                style: TextStyle(
                  fontSize: widget.gameType == GameType.animals ? 64 : 64, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.indigo
                ),
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

  Widget buildOptionCard(dynamic item, Color color) {
    bool isEnglish = widget.gameType == GameType.englishLetters;
    String displayText = widget.gameType == GameType.animals ? item.emoji : item;
    String speakText = widget.gameType == GameType.animals ? item.name : item;

    return GestureDetector(
      onTap: () {
        speak(speakText, isEnglish: isEnglish);
        checkAnswer(item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              displayText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.gameType == GameType.animals ? 56 : 42, 
                color: Colors.white, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
urn GestureDetector(
      onTap: () {
        speak(text);
        checkAnswer(text);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.gameType == GameType.animals ? 28 : 42, 
                color: Colors.white, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
