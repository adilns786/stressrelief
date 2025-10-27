import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const StressLensApp());
}

class StressLensApp extends StatelessWidget {
  const StressLensApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StressLens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.spa, size: 100, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'StressLens',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Find Your Calm',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Home Page with Bottom Navigation
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const GamesPage(),
    const MusicPage(),
    const MoodChartPage(),
    const DailyTipPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StressLens'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2980B9),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Tips'),
        ],
      ),
    );
  }
}

// Games Page
class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildGameCard(
            context,
            'Bubble Popper',
            Icons.bubble_chart,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BubblePopperGame()),
            ),
          ),
          _buildGameCard(
            context,
            'Memory Match',
            Icons.grid_on,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MemoryMatchGame()),
            ),
          ),
          _buildGameCard(
            context,
            'Color Tap',
            Icons.palette,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ColorTapGame()),
            ),
          ),
          _buildGameCard(
            context,
            'Breathing Circle',
            Icons.filter_drama,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BreathingCircle()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bubble Popper Game
class BubblePopperGame extends StatefulWidget {
  const BubblePopperGame({Key? key}) : super(key: key);
  @override
  State<BubblePopperGame> createState() => _BubblePopperGameState();
}

class _BubblePopperGameState extends State<BubblePopperGame>
    with TickerProviderStateMixin {
  final List<Bubble> _bubbles = [];
  int _score = 0;
  Timer? _spawnTimer;
  @override
  void initState() {
    super.initState();
    _startSpawning();
  }

  void _startSpawning() {
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted && _bubbles.length < 10) {
        setState(() {
          _bubbles.add(
            Bubble(
              id: DateTime.now().millisecondsSinceEpoch,
              x: Random().nextDouble() * 0.8 + 0.1,
              y: Random().nextDouble() * 0.8 + 0.1,
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
          );
        });
      }
    });
  }

  void _popBubble(int id) {
    setState(() {
      _bubbles.removeWhere((b) => b.id == id);
      _score++;
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bubble Popper - Score: $_score'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children:
            _bubbles.map((bubble) {
              return Positioned(
                left: bubble.x * MediaQuery.of(context).size.width,
                top: bubble.y * MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onTap: () => _popBubble(bubble.id),
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bubble.color.withOpacity(0.6),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class Bubble {
  final int id;
  final double x;
  final double y;
  final Color color;
  Bubble({
    required this.id,
    required this.x,
    required this.y,
    required this.color,
  });
}

// Memory Match Game
class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({Key? key}) : super(key: key);
  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  List<int> _cards = [];
  List<bool> _revealed = [];
  List<bool> _matched = [];
  int? _firstCard;
  int _moves = 0;
  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _cards = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6]..shuffle();
    _revealed = List.filled(12, false);
    _matched = List.filled(12, false);
    _firstCard = null;
    _moves = 0;
  }

  void _onCardTap(int index) {
    if (_revealed[index] || _matched[index]) return;
    setState(() {
      _revealed[index] = true;
      if (_firstCard == null) {
        _firstCard = index;
      } else {
        _moves++;
        if (_cards[_firstCard!] == _cards[index]) {
          _matched[_firstCard!] = true;
          _matched[index] = true;
          _firstCard = null;
        } else {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _revealed[_firstCard!] = false;
                _revealed[index] = false;
                _firstCard = null;
              });
            }
          });
        }
      }
    });
    if (_matched.every((m) => m)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Congratulations!'),
                  content: Text('You won in $_moves moves!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => _initGame());
                      },
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match - Moves: $_moves'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _onCardTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color:
                      _matched[index]
                          ? Colors.green
                          : _revealed[index]
                          ? Colors.white
                          : Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[700]!, width: 2),
                ),
                child: Center(
                  child:
                      _revealed[index] || _matched[index]
                          ? Icon(
                            _getIcon(_cards[index]),
                            size: 40,
                            color:
                                _matched[index] ? Colors.white : Colors.purple,
                          )
                          : const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 40,
                          ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getIcon(int value) {
    const icons = [
      Icons.favorite,
      Icons.star,
      Icons.brightness_1,
      Icons.ac_unit,
      Icons.pets,
      Icons.cloud,
    ];
    return icons[value - 1];
  }
}

// Color Tap Game
class ColorTapGame extends StatefulWidget {
  const ColorTapGame({Key? key}) : super(key: key);
  @override
  State<ColorTapGame> createState() => _ColorTapGameState();
}

class _ColorTapGameState extends State<ColorTapGame> {
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];
  final List<String> _colorNames = ['RED', 'BLUE', 'GREEN', 'YELLOW'];
  int _targetColorIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _targetColorIndex = Random().nextInt(_colors.length);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        timer.cancel();
        _showGameOver();
      }
    });
  }

  void _onColorTap(int index) {
    if (index == _targetColorIndex) {
      setState(() {
        _score++;
        _targetColorIndex = Random().nextInt(_colors.length);
      });
    } else {
      setState(() => _score = max(0, _score - 1));
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Time\'s Up!'),
            content: Text('Your score: $_score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _score = 0;
                    _timeLeft = 30;
                    _startGame();
                  });
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Tap - Score: $_score | Time: $_timeLeft'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tap: ${_colorNames[_targetColorIndex]}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onColorTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: _colors[index],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Breathing Circle
class BreathingCircle extends StatefulWidget {
  const BreathingCircle({Key? key}) : super(key: key);
  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _phase = 'Inhale';
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 100,
      end: 200,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addListener(() {
      if (_controller.value < 0.5 && _phase != 'Inhale') {
        setState(() => _phase = 'Inhale');
      } else if (_controller.value >= 0.5 && _phase != 'Exhale') {
        setState(() => _phase = 'Exhale');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _phase,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: _animation.value,
                    height: _animation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.3),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
              const Text(
                'Follow the circle\nBreathe slowly',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Music Page
class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);
  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  String? _currentlyPlaying;
  final List<Map<String, dynamic>> _sounds = [
    {'name': 'Rainfall', 'icon': Icons.water_drop, 'color': Colors.blue},
    {'name': 'Ocean Waves', 'icon': Icons.waves, 'color': Colors.cyan},
    {'name': 'Wind', 'icon': Icons.air, 'color': Colors.grey},
    {'name': 'Forest', 'icon': Icons.forest, 'color': Colors.green},
    {'name': 'Soft Piano', 'icon': Icons.piano, 'color': Colors.purple},
    {
      'name': 'Meditation',
      'icon': Icons.self_improvement,
      'color': Colors.orange,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sounds.length,
      itemBuilder: (context, index) {
        final sound = _sounds[index];
        final isPlaying = _currentlyPlaying == sound['name'];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: sound['color'],
              child: Icon(sound['icon'], color: Colors.white),
            ),
            title: Text(
              sound['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
              iconSize: 36,
              color: sound['color'],
              onPressed: () {
                setState(() {
                  _currentlyPlaying = isPlaying ? null : sound['name'];
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isPlaying ? 'Paused' : 'Playing ${sound['name']}',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Mood Chart Page
class MoodChartPage extends StatefulWidget {
  const MoodChartPage({Key? key}) : super(key: key);
  @override
  State<MoodChartPage> createState() => _MoodChartPageState();
}

class _MoodChartPageState extends State<MoodChartPage> {
  final List<Map<String, dynamic>> _moodData = [
    {'day': 'Mon', 'mood': 3},
    {'day': 'Tue', 'mood': 4},
    {'day': 'Wed', 'mood': 2},
    {'day': 'Thu', 'mood': 5},
    {'day': 'Fri', 'mood': 4},
    {'day': 'Sat', 'mood': 5},
    {'day': 'Sun', 'mood': 4},
  ];
  final List<String> _moodEmojis = ['😢', '😞', '😐', '🙂', '😄'];
  int? _selectedMood;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMood = index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mood saved!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _selectedMood == index
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _selectedMood == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _moodEmojis[index],
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          const Text(
            'Your Weekly Mood',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width - 32, 200),
              painter: MoodChartPainter(_moodData),
            ),
          ),
          const SizedBox(height: 20),
          _buildMoodLegend(),
        ],
      ),
    );
  }

  Widget _buildMoodLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Scale',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      _moodEmojis[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Text('Level ${index + 1}'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class MoodChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  MoodChartPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
    final fillPaint =
        Paint()
          ..color = Colors.blue.withOpacity(0.2)
          ..style = PaintingStyle.fill;
    final path = Path();
    final fillPath = Path();
    final stepX = size.width / (data.length - 1);
    final stepY = size.height / 5;
    fillPath.moveTo(0, size.height);
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i]['mood'] * stepY);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      // Draw points
      canvas.drawCircle(Offset(x, y), 6, Paint()..color = Colors.blue);
      // Draw labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i]['day'],
          style: const TextStyle(color: Colors.black87, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 10),
      );
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Daily Tip Page
class DailyTipPage extends StatelessWidget {
  const DailyTipPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _tips = const [
    {
      'title': 'Sleep Well',
      'tip':
          'Aim for 7-9 hours of sleep. Create a bedtime routine to help you wind down.',
    },
    {
      'title': 'Connect with Others',
      'tip':
          'Reach out to a friend or family member. Social connections reduce stress and boost happiness.',
    },
    {
      'title': 'Take Deep Breaths',
      'tip':
          'When you feel stressed, take 5 deep breaths. Inhale for 4 seconds, hold for 4, exhale for 4.',
    },
    {
      'title': 'Stay Hydrated',
      'tip':
          'Drinking water helps maintain your mood and energy levels. Aim for 8 glasses a day.',
    },
    {
      'title': 'Move Your Body',
      'tip':
          'Even a 10-minute walk can boost your mood and reduce stress hormones.',
    },
    {
      'title': 'Practice Gratitude',
      'tip':
          'Write down 3 things you\'re grateful for each day. It shifts your focus to the positive.',
    },
    {
      'title': 'Limit Screen Time',
      'tip':
          'Take breaks from screens every hour. Look at something 20 feet away for 20 seconds.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day % _tips.length;
    final todayTip = _tips[today];
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD89B), Color(0xFFFF9A5E)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.wb_sunny, size: 60, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Daily Tip',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateTime.now().toString().split(' ')[0],
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          todayTip['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2980B9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          todayTip['tip']!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'More Tips',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ..._tips.asMap().entries.where((e) => e.key != today).map((
                  entry,
                ) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.orange,
                        ),
                      ),
                      title: Text(
                        entry.value['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        entry.value['tip']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: Text(entry.value['title']!),
                                content: Text(entry.value['tip']!),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() => _isDarkMode = value);
              },
            ),
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() => _soundEnabled = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
