import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// 🎮 پول‌چی - بازی شبیه‌سازی اقتصادی ایرانی
// 📍 الیگودرز، ۱۴۰۵
// ============================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PolChiApp());
}

// ============================================================
// 🎨 تم رنگی
// ============================================================
class AppTheme {
  static const gold = Color(0xFFFFD700);
  static const green = Color(0xFF4CAF50);
  static const red = Color(0xFFF44336);
  static const blue = Color(0xFF2196F3);
  static const brown = Color(0xFF8B4513);
  static const dark = Color(0xFF1A1A1A);
  static const darkCard = Color(0xFF2A2A2A);
  static const grass = Color(0xFF2D5016);
  static const purple = Color(0xFF9C27B0);
  static const orange = Color(0xFFFF9800);
}

// ============================================================
// 💾 ذخیره‌سازی
// ============================================================
class SaveManager {
  static const String _keyMoney = 'money';
  static const String _keyBoofeLevel = 'boofe_level';
  static const String _keyChaiKhaneOwned = 'chai_khane_owned';
  static const String _keyInterlude1 = 'interlude1_shown';
  static const String _keyInterlude2 = 'interlude2_shown';
  static const String _keyInterlude3 = 'interlude3_shown';
  static const String _keyEnding1 = 'ending1_shown';
  static const String _keyStorySeen = 'story_seen';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyMusicEnabled = 'music_enabled';
  static const String _keyHapticEnabled = 'haptic_enabled';
  static const String _keyTotalEarned = 'total_earned';
  static const String _keyTotalClicks = 'total_clicks';

  static Future<void> save({
    required int money,
    required int boofeLevel,
    required bool chaiKhaneOwned,
    required bool interlude1Shown,
    required bool interlude2Shown,
    required bool interlude3Shown,
    required bool ending1Shown,
    required bool storySeen,
    required bool soundEnabled,
    required bool musicEnabled,
    required bool hapticEnabled,
    required int totalEarned,
    required int totalClicks,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMoney, money);
    await prefs.setInt(_keyBoofeLevel, boofeLevel);
    await prefs.setBool(_keyChaiKhaneOwned, chaiKhaneOwned);
    await prefs.setBool(_keyInterlude1, interlude1Shown);
    await prefs.setBool(_keyInterlude2, interlude2Shown);
    await prefs.setBool(_keyInterlude3, interlude3Shown);
    await prefs.setBool(_keyEnding1, ending1Shown);
    await prefs.setBool(_keyStorySeen, storySeen);
    await prefs.setBool(_keySoundEnabled, soundEnabled);
    await prefs.setBool(_keyMusicEnabled, musicEnabled);
    await prefs.setBool(_keyHapticEnabled, hapticEnabled);
    await prefs.setInt(_keyTotalEarned, totalEarned);
    await prefs.setInt(_keyTotalClicks, totalClicks);
  }

  static Future<Map<String, dynamic>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'money': prefs.getInt(_keyMoney) ?? 0,
      'boofeLevel': prefs.getInt(_keyBoofeLevel) ?? 1,
      'chaiKhaneOwned': prefs.getBool(_keyChaiKhaneOwned) ?? false,
      'interlude1Shown': prefs.getBool(_keyInterlude1) ?? false,
      'interlude2Shown': prefs.getBool(_keyInterlude2) ?? false,
      'interlude3Shown': prefs.getBool(_keyInterlude3) ?? false,
      'ending1Shown': prefs.getBool(_keyEnding1) ?? false,
      'storySeen': prefs.getBool(_keyStorySeen) ?? false,
      'soundEnabled': prefs.getBool(_keySoundEnabled) ?? true,
      'musicEnabled': prefs.getBool(_keyMusicEnabled) ?? true,
      'hapticEnabled': prefs.getBool(_keyHapticEnabled) ?? true,
      'totalEarned': prefs.getInt(_keyTotalEarned) ?? 0,
      'totalClicks': prefs.getInt(_keyTotalClicks) ?? 0,
    };
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// ============================================================
// 🚀 اپ اصلی
// ============================================================
class PolChiApp extends StatelessWidget {
  const PolChiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'پول‌چی',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppTheme.gold,
        scaffoldBackgroundColor: AppTheme.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.dark,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(
          name: '/story',
          page: () {
            final args = Get.arguments;
            if (args is Map) {
              return StoryPage(
                chapter: args['chapter'] ?? 1,
                type: args['type'] ?? 'intro',
              );
            }
            return const StoryPage(chapter: 1, type: 'intro');
          },
        ),
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/upgrade', page: () => const UpgradePage()),
        GetPage(name: '/shop', page: () => const ShopPage()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
      ],
    );
  }
}

// ============================================================
// 🔊 کمکی صدا
// ============================================================
class SoundHelper {
  static bool soundEnabled = true;
  static bool musicEnabled = true;
  static bool hapticEnabled = true;

  static void click() {
    if (hapticEnabled) HapticFeedback.lightImpact();
  }

  static void upgrade() {
    if (hapticEnabled) HapticFeedback.mediumImpact();
  }

  static void buy() {
    if (hapticEnabled) HapticFeedback.heavyImpact();
  }

  static void coin() {
    if (hapticEnabled) HapticFeedback.lightImpact();
  }
}

// ============================================================
// 🚀 صفحه اسپلش
// ============================================================
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSave();
  }

  Future<void> _checkSave() async {
    final data = await SaveManager.load();
    final storySeen = data['storySeen'] as bool;

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (storySeen) {
      Get.offAllNamed('/');
    } else {
      Get.offAllNamed('/story', arguments: {
        'chapter': 1,
        'type': 'intro',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageHelper.load(
              path: 'assets/images/logo.png',
              fallbackEmoji: '💰',
              width: 200,
              height: 100,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: AppTheme.gold),
            const SizedBox(height: 16),
            const Text(
              'در حال بارگذاری...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 🖼️ کمکی تصویر
// ============================================================
class ImageHelper {
  static Widget load({
    required String path,
    required String fallbackEmoji,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Key? key,
  }) {
    return Image.asset(
      path,
      key: key,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: Center(
            child: Text(
              fallbackEmoji,
              style: TextStyle(fontSize: (width ?? 100) * 0.4),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// 📖 صفحه داستان
// ============================================================
class StoryPage extends StatefulWidget {
  final int chapter;
  final String type;
  const StoryPage({super.key, this.chapter = 1, this.type = 'intro'});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int _currentLine = 0;
  bool _showButton = false;

  final Map<String, String> speakerImages = {
    'ممد': 'mamad',
    'مادر': 'mother',
    'بابا': 'baba',
    'بابابزرگ': 'bababozorg',
    'رضا': 'reza',
    'علی': 'ali',
    'حاج آقا': 'haj_agha',
    'مهسا': 'mahsa',
  };

  List<Map<String, String>> get _lines {
    if (widget.chapter == 1) {
      switch (widget.type) {
        case 'intro': return _chapter1Intro();
        case 'interlude1': return _chapter1Interlude1();
        case 'interlude2': return _chapter1Interlude2();
        case 'interlude3': return _chapter1Interlude3();
        case 'ending': return _chapter1Ending();
      }
    }
    return _chapter1Intro();
  }

  @override
  void initState() {
    super.initState();
    _startStory();
  }

  void _startStory() async {
    for (int i = 0; i < _lines.length; i++) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() => _currentLine = i + 1);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _showButton = true);
  }

  void _skipForward() {
    if (_currentLine < _lines.length) {
      setState(() {
        _currentLine = _lines.length;
        _showButton = true;
      });
    }
  }

  Future<void> _onContinue() async {
    if (widget.type == 'intro') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('story_seen', true);
    }
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final currentLine = _currentLine > 0 ? _lines[_currentLine - 1] : null;
    final speaker = currentLine?['speaker'] ?? '';
    final imageName = speakerImages[speaker] ?? 'mamad';
    final imagePath = 'assets/images/characters/$imageName.png';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: _skipForward,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentLine > 0)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ImageHelper.load(
                      key: ValueKey(imagePath),
                      path: imagePath,
                      fallbackEmoji: '👤',
                      width: 200,
                      height: 200,
                    ),
                  ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _lines.take(_currentLine).map((line) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            line['speaker']!.isEmpty
                                ? line['text']!
                                : '${line['speaker']}: ${line['text']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.6,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_showButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        widget.type == 'intro' ? 'شروع بازی' : 'ادامه بازی',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _chapter1Intro() {
    return [
      {'speaker': '', 'text': 'الیگودرز. سال ۱۴۰۵.'},
      {'speaker': '', 'text': 'اسم من ممده. ۲۵ سالمه.'},
      {'speaker': '', 'text': 'توی یه روستای کوچیک زندگی می‌کنم.'},
      {'speaker': '', 'text': 'روستامون هیچ مغازه‌ای نداره.'},
      {'speaker': 'مادر', 'text': 'ممد! پاشو! ظهر شده!'},
      {'speaker': 'ممد', 'text': 'مادر، من کارآفرینم.'},
      {'speaker': 'بابابزرگ', 'text': 'ممد، این چرخ‌دستی چیه؟'},
      {'speaker': 'ممد', 'text': 'سرمایه اولمه.'},
      {'speaker': 'بابابزرگ', 'text': 'پول مثل زن می‌مونه.'},
      {'speaker': 'ممد', 'text': 'زنت ولت کرد؟'},
      {'speaker': 'بابابزرگ', 'text': 'ممد! برو کارت رو بکن!'},
      {'speaker': 'رضا', 'text': 'ممد، بازم بیکاری؟'},
      {'speaker': 'ممد', 'text': 'می‌خوام دکان بزنم. سر جاده.'},
      {'speaker': 'حاج آقا', 'text': 'تو ممدی؟ شنیدم می‌خوای دکان باز کنی.'},
      {'speaker': 'ممد', 'text': 'بله. بوفه.'},
      {'speaker': 'حاج آقا', 'text': 'بوفه؟ من ۳۰ ساله اینجام.'},
      {'speaker': 'ممد', 'text': 'من تازه شروع کردم.'},
      {'speaker': 'حاج آقا', 'text': '... ببینم چیکار می‌کنی.'},
      {'speaker': '', 'text': 'اولین فروش...'},
      {'speaker': 'مشتری', 'text': 'آب داری؟'},
      {'speaker': 'ممد', 'text': 'بله. ۵ تومن.'},
      {'speaker': 'ممد', 'text': 'هدفم: ۱ میلیون تومن.'},
      {'speaker': '', 'text': 'حالا بازی شروع می‌شه!'},
    ];
  }

  List<Map<String, String>> _chapter1Interlude1() {
    return [
      {'speaker': 'ممد', 'text': '[با هیجان] بوفه سطح ۲ شد!'},
      {'speaker': 'ممد', 'text': 'حالا درآمد بیشتره.'},
      {'speaker': 'ممد', 'text': 'ولی هنوز اول راهم.'},
    ];
  }

  List<Map<String, String>> _chapter1Interlude2() {
    return [
      {'speaker': 'ممد', 'text': '[با خستگی] ۱۰۰ هزار تومن جمع کردم.'},
      {'speaker': 'ممد', 'text': '۷۵ کیلومتر هر روز...'},
      {'speaker': 'ممد', 'text': 'باید ادامه بدم.'},
    ];
  }

  List<Map<String, String>> _chapter1Interlude3() {
    return [
      {'speaker': 'ممد', 'text': '[با هیجان] ۵۰۰ هزار تومن!'},
      {'speaker': 'ممد', 'text': 'نزدیک ۱ میلیون!'},
      {'speaker': 'ممد', 'text': 'چای‌خانه منتظرمه.'},
    ];
  }

  List<Map<String, String>> _chapter1Ending() {
    return [
      {'speaker': 'ممد', 'text': '[با هیجان] ۱ میلیون! رسیدم!'},
      {'speaker': 'ممد', 'text': 'حالا می‌تونم چای‌خانه بخرم!'},
      {'speaker': 'حاج آقا', 'text': '[با ترس] این پسر داره موفق می‌شه.'},
      {'speaker': 'حاج آقا', 'text': 'باید یه فکری بکنم.'},
      {'speaker': 'ممد', 'text': '[با لبخند] فصل ۱ تموم شد.'},
      {'speaker': 'ممد', 'text': 'فصل ۲: چای‌خانه.'},
      {'speaker': '', 'text': '[به‌زودی]'},
    ];
  }
}

// ============================================================
// 🏠 صفحه اصلی
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int money = 0;
  int boofePending = 0;
  int boofeLevel = 1;
  bool chaiKhaneOwned = false;
  int chaiKhanePrice = 1000000;
  int hajAghaPending = 0;
  int hajAghaLevel = 3;

  bool interlude1Shown = false;
  bool interlude2Shown = false;
  bool interlude3Shown = false;
  bool ending1Shown = false;

  bool soundEnabled = true;
  bool musicEnabled = true;
  bool hapticEnabled = true;
  int totalEarned = 0;
  int totalClicks = 0;

  Timer? _boofeTimer;
  Timer? _hajAghaTimer;
  Timer? _autoSaveTimer;

  int get boofeMax => _getBoofeMax(boofeLevel);
  int get boofeIncome => _getBoofeIncome(boofeLevel);
  int get boofeUpgradeCost => _getBoofeUpgradeCost(boofeLevel);
  int get hajAghaMax => hajAghaLevel * 10;
  int get hajAghaIncome => hajAghaLevel * 10;

  int _getBoofeMax(int level) {
    const values = [10, 20, 50, 100, 200, 500, 1000, 5000, 20000, 100000];
    return level <= 10 ? values[level - 1] : 100000;
  }

  int _getBoofeIncome(int level) {
    const values = [10, 20, 50, 100, 200, 500, 1000, 5000, 20000, 100000];
    return level <= 10 ? values[level - 1] : 100000;
  }

  int _getBoofeUpgradeCost(int level) {
    const values = [10000, 50000, 200000, 500000, 1000000, 5000000, 20000000, 100000000, 500000000, 0];
    return level <= 10 ? values[level - 1] : 0;
  }

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  @override
  void dispose() {
    _boofeTimer?.cancel();
    _hajAghaTimer?.cancel();
    _autoSaveTimer?.cancel();
    _saveGame();
    super.dispose();
  }

  Future<void> _loadGame() async {
    final data = await SaveManager.load();
    if (!mounted) return;

    setState(() {
      money = data['money'] as int;
      boofeLevel = data['boofeLevel'] as int;
      chaiKhaneOwned = data['chaiKhaneOwned'] as bool;
      interlude1Shown = data['interlude1Shown'] as bool;
      interlude2Shown = data['interlude2Shown'] as bool;
      interlude3Shown = data['interlude3Shown'] as bool;
      ending1Shown = data['ending1Shown'] as bool;
      soundEnabled = data['soundEnabled'] as bool;
      musicEnabled = data['musicEnabled'] as bool;
      hapticEnabled = data['hapticEnabled'] as bool;
      totalEarned = data['totalEarned'] as int;
      totalClicks = data['totalClicks'] as int;
    });

    SoundHelper.soundEnabled = soundEnabled;
    SoundHelper.musicEnabled = musicEnabled;
    SoundHelper.hapticEnabled = hapticEnabled;

    _startTimers();
  }

  Future<void> _saveGame() async {
    await SaveManager.save(
      money: money,
      boofeLevel: boofeLevel,
      chaiKhaneOwned: chaiKhaneOwned,
      interlude1Shown: interlude1Shown,
      interlude2Shown: interlude2Shown,
      interlude3Shown: interlude3Shown,
      ending1Shown: ending1Shown,
      storySeen: true,
      soundEnabled: soundEnabled,
      musicEnabled: musicEnabled,
      hapticEnabled: hapticEnabled,
      totalEarned: totalEarned,
      totalClicks: totalClicks,
    );
  }

  void _startTimers() {
    _boofeTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (boofePending < boofeMax) {
            boofePending += boofeIncome;
            if (boofePending > boofeMax) boofePending = boofeMax;
          }
        });
      }
    });

    _hajAghaTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (hajAghaPending < hajAghaMax) {
            hajAghaPending += hajAghaIncome;
            if (hajAghaPending > hajAghaMax) hajAghaPending = hajAghaMax;
          }
        });
      }
    });

    _autoSaveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _saveGame();
    });
  }

  void _collectBoofe() {
    if (boofePending > 0) {
      setState(() {
        money += boofePending;
        totalEarned += boofePending;
        totalClicks++;
        boofePending = 0;
      });
      SoundHelper.click();
      _checkStoryTriggers();
    }
  }

  void _checkStoryTriggers() {
    if (money >= 100000 && !interlude2Shown) {
      interlude2Shown = true;
      _saveGame();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Get.toNamed('/story', arguments: {
            'chapter': 1,
            'type': 'interlude2',
          });
        }
      });
      return;
    }

    if (money >= 500000 && !interlude3Shown) {
      interlude3Shown = true;
      _saveGame();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Get.toNamed('/story', arguments: {
            'chapter': 1,
            'type': 'interlude3',
          });
        }
      });
      return;
    }

    if (money >= 1000000 && !ending1Shown) {
      ending1Shown = true;
      _saveGame();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Get.toNamed('/story', arguments: {
            'chapter': 1,
            'type': 'ending',
          });
        }
      });
      return;
    }
  }

  void _upgradeBoofe() {
    if (boofeLevel >= 10) {
      Get.snackbar('بوفه', 'به حداکثر سطح رسیده!',
        backgroundColor: AppTheme.darkCard, colorText: Colors.white);
      return;
    }
    if (money >= boofeUpgradeCost) {
      setState(() {
        money -= boofeUpgradeCost;
        boofeLevel++;
      });
      SoundHelper.upgrade();
      _saveGame();

      Get.snackbar('بوفه ارتقا یافت!', 'سطح $boofeLevel',
        backgroundColor: AppTheme.green, colorText: Colors.white);

      if (boofeLevel == 2 && !interlude1Shown) {
        interlude1Shown = true;
        _saveGame();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Get.toNamed('/story', arguments: {
              'chapter': 1,
              'type': 'interlude1',
            });
          }
        });
      }
    } else {
      Get.snackbar('پول کافی نداری!', 'نیاز: ${_formatMoney(boofeUpgradeCost)}',
        backgroundColor: AppTheme.red, colorText: Colors.white);
    }
  }

  void _buyChaiKhane() {
    if (chaiKhaneOwned) return;
    if (money >= chaiKhanePrice) {
      setState(() {
        money -= chaiKhanePrice;
        chaiKhaneOwned = true;
      });
      SoundHelper.buy();
      _saveGame();
      Get.snackbar('تبریک!', 'چای‌خانه خریدی!',
        backgroundColor: AppTheme.green, colorText: Colors.white);
    } else {
      Get.snackbar('پول کافی نداری!', 'نیاز: ${_formatMoney(chaiKhanePrice)}',
        backgroundColor: AppTheme.red, colorText: Colors.white);
    }
  }

  void _watchAd() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('تبلیغ', style: TextStyle(color: AppTheme.gold)),
        content: const Text(
          'تبلیغ جایزه‌ای\n(اینجا تبلیغ تپسل میاد)',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              setState(() {
                money += 10000;
                totalEarned += 10000;
              });
              SoundHelper.coin();
              Get.snackbar('جایزه!', '+۱۰,۰۰۰ تومن',
                backgroundColor: AppTheme.green, colorText: Colors.white);
            },
            child: const Text('دریافت جایزه', style: TextStyle(color: AppTheme.gold)),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('بستن', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  String _formatMoney(int amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} میلیارد';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} میلیون';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} هزار';
    }
    return '$amount';
  }

  @override
  Widget build(BuildContext context) {
    final boofeIsFull = boofePending >= boofeMax;
    final canUpgradeBoofe = money >= boofeUpgradeCost && boofeLevel < 10;
    final canBuyChaiKhane = money >= chaiKhanePrice && !chaiKhaneOwned;
    final progress = (money / 1000000).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppTheme.grass,
      body: SafeArea(
        child: Stack(
          children: [
            // ===== پس‌زمینه =====
            Positioned.fill(
              child: ImageHelper.load(
                path: 'assets/images/map.png',
                fallbackEmoji: '🏘️',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // ===== دکان ممد =====
            Positioned(
              bottom: 420,
              left: 15,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _collectBoofe,
                    child: ImageHelper.load(
                      path: 'assets/images/boofe.png',
                      fallbackEmoji: '🏪',
                      width: 130,
                      height: 130,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.gold, width: 2),
                    ),
                    child: Text(
                      'ممد - سطح $boofeLevel',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // ===== آیکون پول بوفه =====
            Positioned(
              bottom: 440,
              left: 115,
              child: GestureDetector(
                onTap: _collectBoofe,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: boofeIsFull ? AppTheme.red : AppTheme.gold,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (boofeIsFull ? AppTheme.red : AppTheme.gold)
                            .withOpacity(boofePending > 0 ? 0.7 : 0.2),
                        blurRadius: boofePending > 0 ? 15 : 5,
                        spreadRadius: boofePending > 0 ? 3 : 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 4),
                      Text(
                        '$boofePending/$boofeMax',
                        style: TextStyle(
                          color: boofeIsFull ? AppTheme.red : AppTheme.gold,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== دکان حاج آقا =====
            Positioned(
              bottom: 420,
              right: 15,
              child: Column(
                children: [
                  ImageHelper.load(
                    path: 'assets/images/haj_agha_shop.png',
                    fallbackEmoji: '🏚️',
                    width: 130,
                    height: 130,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.red, width: 2),
                    ),
                    child: Text(
                      'حاج آقا - سطح $hajAghaLevel',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // ===== آیکون پول حاج آقا =====
            Positioned(
              bottom: 440,
              right: 115,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.red, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💰', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text(
                      '$hajAghaPending/$hajAghaMax',
                      style: const TextStyle(color: AppTheme.red, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // ===== نشانگر هدف =====
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.gold.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🎯 هدف: ۱ میلیون',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade800,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.gold),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== دکمه‌های ارتقا و خرید =====
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _upgradeBoofe,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: canUpgradeBoofe
                              ? AppTheme.green.withOpacity(0.9)
                              : Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: canUpgradeBoofe ? AppTheme.green : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('🔼', style: TextStyle(fontSize: 22)),
                            const SizedBox(height: 2),
                            Text(
                              'ارتقا بوفه',
                              style: TextStyle(
                                color: canUpgradeBoofe ? Colors.white : Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              boofeLevel < 10 ? _formatMoney(boofeUpgradeCost) : 'حداکثر',
                              style: TextStyle(
                                color: canUpgradeBoofe ? Colors.white : Colors.grey,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: _buyChaiKhane,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: chaiKhaneOwned
                              ? AppTheme.green.withOpacity(0.5)
                              : canBuyChaiKhane
                                  ? AppTheme.blue.withOpacity(0.9)
                                  : Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: chaiKhaneOwned
                                ? AppTheme.green
                                : canBuyChaiKhane
                                    ? AppTheme.blue
                                    : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              chaiKhaneOwned ? '✅' : '☕',
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              chaiKhaneOwned ? 'چای‌خانه' : 'خرید چای‌خانه',
                              style: TextStyle(
                                color: chaiKhaneOwned || canBuyChaiKhane ? Colors.white : Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              chaiKhaneOwned ? 'خریداری شده' : _formatMoney(chaiKhanePrice),
                              style: TextStyle(
                                color: chaiKhaneOwned || canBuyChaiKhane ? Colors.white : Colors.grey,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: _watchAd,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.purple.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.purple, width: 2),
                        ),
                        child: const Column(
                          children: [
                            Text('🎁', style: TextStyle(fontSize: 22)),
                            SizedBox(height: 2),
                            Text(
                              'تبلیغ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '+۱۰,۰۰۰',
                              style: TextStyle(color: Colors.white, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== نوار بالا =====
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildTopBar(),
            ),

            // ===== نوار پایین =====
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageHelper.load(
            path: 'assets/images/logo.png',
            fallbackEmoji: '💰',
            width: 60,
            height: 30,
          ),
          Column(
            children: [
              Text(
                _formatMoney(money),
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'سطح $boofeLevel: +$boofeIncome',
                style: const TextStyle(color: AppTheme.green, fontSize: 10),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Get.toNamed('/settings'),
            child: const Icon(Icons.settings, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.dark.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: AppTheme.gold.withOpacity(0.7), width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _menuButton('داستان', '📖', () {
            Get.toNamed('/story', arguments: {
              'chapter': 1,
              'type': 'intro',
            });
          }),
          _menuButton('ارتقا', '🔼', () => Get.toNamed('/upgrade')),
          _menuButton('فروشگاه', '🛒', () => Get.toNamed('/shop')),
          _menuButton('رقیب', '👴', () {
            Get.snackbar('حاج آقا', 'رقیب قدیمی...',
              backgroundColor: AppTheme.darkCard, colorText: Colors.white);
          }),
        ],
      ),
    );
  }

  Widget _menuButton(String label, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.blue.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.blue),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 🔼 صفحه ارتقا
// ============================================================
class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key});

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final List<Map<String, dynamic>> businesses = [
    {
      'name': 'بوفه چوبی',
      'price': 0,
      'income': 10,
      'emoji': '🏪',
      'image': 'boofe.png',
      'level': 1,
      'owned': true,
    },
    {
      'name': 'چای‌خانه',
      'price': 1000000,
      'income': 100,
      'emoji': '☕',
      'image': 'chai_khane.png',
      'level': 0,
      'owned': false,
    },
    {
      'name': 'ساندویچی',
      'price': 5000000,
      'income': 500,
      'emoji': '🥪',
      'image': 'sandwichi.png',
      'level': 0,
      'owned': false,
    },
    {
      'name': 'بستنی‌فروشی',
      'price': 150000000,
      'income': 15000,
      'emoji': '🍦',
      'image': 'bastani.png',
      'level': 0,
      'owned': false,
    },
    {
      'name': 'رستوران',
      'price': 1000000000,
      'income': 100000,
      'emoji': '🍽️',
      'image': 'restaurant.png',
      'level': 0,
      'owned': false,
    },
    {
      'name': 'سوپرمارکت',
      'price': 10000000000,
      'income': 1000000,
      'emoji': '🛒',
      'image': 'supermarket.png',
      'level': 0,
      'owned': false,
    },
  ];

  String _formatMoney(int amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} میلیارد';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} میلیون';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} هزار';
    }
    return '$amount';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      appBar: AppBar(
        title: const Text('ارتقا'),
        backgroundColor: AppTheme.dark,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: businesses.length,
        itemBuilder: (context, index) {
          final b = businesses[index];
          final owned = b['owned'] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: owned ? AppTheme.green : Colors.grey.shade700,
                width: owned ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                ImageHelper.load(
                  path: 'assets/images/${b['image']}',
                  fallbackEmoji: b['emoji'] as String,
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            b['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (owned) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'خریداری شده',
                                style: TextStyle(color: Colors.white, fontSize: 9),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'درآمد: +${b['income']} هر ۵ ثانیه',
                        style: const TextStyle(color: AppTheme.green, fontSize: 12),
                      ),
                      Text(
                        b['price'] == 0 ? 'رایگان' : 'قیمت: ${_formatMoney(b['price'] as int)}',
                        style: const TextStyle(color: AppTheme.gold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      b['name'] as String,
                      owned ? 'ارتقا' : 'خرید',
                      backgroundColor: AppTheme.darkCard,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: owned ? AppTheme.green : AppTheme.blue,
                  ),
                  child: Text(owned ? 'ارتقا' : 'خرید'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// 🛒 صفحه فروشگاه سکه
// ============================================================
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final packages = [
      {'coins': 10000, 'price': 10000, 'bonus': 0, 'emoji': '🪙'},
      {'coins': 75000, 'price': 50000, 'bonus': 50, 'emoji': '💰'},
      {'coins': 200000, 'price': 100000, 'bonus': 100, 'emoji': '💎'},
      {'coins': 1250000, 'price': 500000, 'bonus': 150, 'emoji': '👑'},
      {'coins': 3000000, 'price': 1000000, 'bonus': 200, 'emoji': '🏆'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.dark,
      appBar: AppBar(
        title: const Text('فروشگاه سکه'),
        backgroundColor: AppTheme.dark,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final p = packages[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.purple.withOpacity(0.3), AppTheme.blue.withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.gold, width: 2),
            ),
            child: Row(
              children: [
                Text(p['emoji'] as String, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${p['coins']} سکه',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if ((p['bonus'] as int) > 0)
                        Text(
                          '+${p['bonus']}٪ جایزه',
                          style: const TextStyle(color: AppTheme.green, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar('فروشگاه', 'به‌زودی...',
                      backgroundColor: AppTheme.darkCard, colorText: Colors.white);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('${p['price']} تومن'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// ⚙️ صفحه تنظیمات
// ============================================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool soundEnabled = true;
  bool musicEnabled = true;
  bool hapticEnabled = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SaveManager.load();
    setState(() {
      soundEnabled = data['soundEnabled'] as bool;
      musicEnabled = data['musicEnabled'] as bool;
      hapticEnabled = data['hapticEnabled'] as bool;
    });
  }

  Future<void> _save() async {
    final data = await SaveManager.load();
    await SaveManager.save(
      money: data['money'] as int,
      boofeLevel: data['boofeLevel'] as int,
      chaiKhaneOwned: data['chaiKhaneOwned'] as bool,
      interlude1Shown: data['interlude1Shown'] as bool,
      interlude2Shown: data['interlude2Shown'] as bool,
      interlude3Shown: data['interlude3Shown'] as bool,
      ending1Shown: data['ending1Shown'] as bool,
      storySeen: data['storySeen'] as bool,
      soundEnabled: soundEnabled,
      musicEnabled: musicEnabled,
      hapticEnabled: hapticEnabled,
      totalEarned: data['totalEarned'] as int,
      totalClicks: data['totalClicks'] as int,
    );
    SoundHelper.soundEnabled = soundEnabled;
    SoundHelper.musicEnabled = musicEnabled;
    SoundHelper.hapticEnabled = hapticEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      appBar: AppBar(
        title: const Text('تنظیمات'),
        backgroundColor: AppTheme.dark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('صدا', style: TextStyle(color: Colors.white)),
            value: soundEnabled,
            activeColor: AppTheme.gold,
            onChanged: (v) {
              setState(() => soundEnabled = v);
              _save();
            },
          ),
          SwitchListTile(
            title: const Text('موسیقی', style: TextStyle(color: Colors.white)),
            value: musicEnabled,
            activeColor: AppTheme.gold,
            onChanged: (v) {
              setState(() => musicEnabled = v);
              _save();
            },
          ),
          SwitchListTile(
            title: const Text('لرزش', style: TextStyle(color: Colors.white)),
            value: hapticEnabled,
            activeColor: AppTheme.gold,
            onChanged: (v) {
              setState(() => hapticEnabled = v);
              _save();
            },
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.grey),
          const SizedBox(height: 16),
          const ListTile(
            title: Text('درباره', style: TextStyle(color: Colors.white)),
            subtitle: Text(
              'پول‌چی - نسخه ۱.۰.۰\nساخته شده با ❤️ در الیگودرز',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}