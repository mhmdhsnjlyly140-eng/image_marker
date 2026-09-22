import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/story', page: () => const StoryPage()),
        GetPage(name: '/upgrade', page: () => const UpgradePage()),
      ],
    );
  }
}

// ============================================================
// 🖼️ کمکی تصویر (با Fallback)
// ============================================================
class ImageHelper {
  static Widget load({
    required String path,
    required String fallbackEmoji,
    double? width,
    double? height,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? 100,
          height: height ?? 100,
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
// 🏠 صفحه اصلی
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int money = 0;
  int perSecond = 1;
  bool isRunning = true;

  @override
  void initState() {
    super.initState();
    _startIncome();
  }

  void _startIncome() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && isRunning) {
        setState(() => money += perSecond);
        _startIncome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildMoney(),
            Expanded(child: _buildShop()),
            _buildStatus(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  // نوار بالا
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          ImageHelper.load(
            path: 'assets/images/logo.png',
            fallbackEmoji: '💰',
            width: 100,
            height: 40,
          ),
          Row(
            children: [
              const Icon(Icons.star, color: AppTheme.gold, size: 20),
              const SizedBox(width: 4),
              const Text('۱', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  // نمایش پول
  Widget _buildMoney() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            '$money تومن',
            style: const TextStyle(
              color: AppTheme.gold,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+$perSecond تومن/ثانیه',
            style: const TextStyle(color: AppTheme.green, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // دکان
  Widget _buildShop() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() => money += 10);
        },
        child: ImageHelper.load(
          path: 'assets/images/businesses/boofe.png',
          fallbackEmoji: '🏪',
          width: 250,
          height: 250,
        ),
      ),
    );
  }

  // وضعیت
  Widget _buildStatus() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statusItem('☀️', 'آفتابی'),
          _statusItem('🚗', 'پیکان'),
          _statusItem('👥', '۵ توریست'),
          _statusItem('⭐', '۲.۵'),
        ],
      ),
    );
  }

  Widget _statusItem(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  // دکمه‌ها
  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _menuButton('داستان', '📖', () => Get.toNamed('/story')),
          _menuButton('ارتقا', '🔼', () => Get.toNamed('/upgrade')),
          _menuButton('رقیب', '👴', () {}),
        ],
      ),
    );
  }

  Widget _menuButton(String label, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.blue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.blue),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 📖 صفحه داستان
// ============================================================
class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final List<Map<String, String>> _lines = [
    {'speaker': '', 'text': 'الیگودرز. سال ۱۴۰۵.'},
    {'speaker': '', 'text': 'اسم من ممده.'},
    {'speaker': '', 'text': 'خونه‌مون ۷۵ کیلومتر تا آبشار فاصله داره.'},
    {'speaker': '', 'text': 'هر روز صبح، ساعت ۵ بیدار می‌شم.'},
    {'speaker': '', 'text': 'ماشین سوار می‌شم. ۷۵ کیلومتر می‌رم.'},
    {'speaker': '', 'text': 'اونجا یه دکان ساده دارم.'},
    {'speaker': '', 'text': 'هدفم؟ بزرگ کردنش.'},
  ];

  int _currentLine = 0;

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
  }

  void _nextLine() {
    if (_currentLine < _lines.length) {
      setState(() => _currentLine++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: _nextLine,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شخصیت ممد
                if (_currentLine > 0)
                  ImageHelper.load(
                    path: 'assets/images/characters/mamad.png',
                    fallbackEmoji: '👨',
                    width: 200,
                    height: 200,
                  ),
                const SizedBox(height: 24),
                // متن
                ..._lines.take(_currentLine).map((line) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      line['text']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 32),
                // دکمه ادامه
                if (_currentLine >= _lines.length)
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('شروع بازی'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 🔼 صفحه ارتقا
// ============================================================
class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    final businesses = [
      {'name': 'بوفه چوبی', 'price': 'رایگان', 'income': '۱ تومن/ثانیه', 'emoji': '🏪', 'image': 'boofe.png'},
      {'name': 'چای‌خانه', 'price': '۵۰۰', 'income': '۵ تومن/ثانیه', 'emoji': '☕', 'image': 'chai_khane.png'},
      {'name': 'بستنی‌فروشی', 'price': '۵,۰۰۰', 'income': '۲۵ تومن/ثانیه', 'emoji': '🍦', 'image': 'bastani.png'},
      {'name': 'ساندویچی', 'price': '۵۰,۰۰۰', 'income': '۱۵۰ تومن/ثانیه', 'emoji': '🥪', 'image': 'sandwichi.png'},
      {'name': 'رستوران آبشار', 'price': '۱,۰۰۰,۰۰۰', 'income': '۱,۰۰۰ تومن/ثانیه', 'emoji': '🍽️', 'image': 'restaurant.png'},
    ];

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
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: Row(
              children: [
                ImageHelper.load(
                  path: 'assets/images/businesses/${b['image']}',
                  fallbackEmoji: b['emoji']!,
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'درآمد: ${b['income']}',
                        style: const TextStyle(color: AppTheme.green, fontSize: 12),
                      ),
                      Text(
                        'قیمت: ${b['price']}',
                        style: const TextStyle(color: AppTheme.gold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blue,
                  ),
                  child: const Text('خرید'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
