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
      initialRoute: '/story',  // ← اول داستان
      getPages: [
        GetPage(name: '/story', page: () => const StoryPage()),
        GetPage(name: '/', page: () => const HomePage()),
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
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      path,
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
              style: TextStyle(
                fontSize: (width ?? 100) * 0.4,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// 📖 صفحه داستان (خودکار)
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
    {'speaker': '', 'text': 'ولی راه سخته.'},
    {'speaker': '', 'text': 'پول کمه. رقبا زیادن.'},
    {'speaker': '', 'text': 'ولی من تسلیم نمی‌شم.'},
  ];

  int _currentLine = 0;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _startStory();
  }

  void _startStory() async {
    // اول خالی، بعد خط به خط
    for (int i = 0; i < _lines.length; i++) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() => _currentLine = i + 1);
    }
    // بعد از اتمام، دکمه رو نشون بده
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _showButton = true);
  }

  // کاربر می‌تونه با کلیک، سرعت بده
  void _skipForward() {
    if (_currentLine < _lines.length) {
      setState(() => _currentLine = _lines.length);
      setState(() => _showButton = true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // شخصیت ممد (وقتی خط اول رد شد)
                if (_currentLine > 0)
                  ImageHelper.load(
                    path: 'assets/images/characters/mamad.png',
                    fallbackEmoji: '👨',
                    width: 180,
                    height: 180,
                  ),
                const SizedBox(height: 24),

                // متن داستان
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _lines.take(_currentLine).map((line) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            line['text']!,
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

                // دکمه شروع بازی
                if (_showButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // برو به نقشه (و داستان رو پاک کن)
                        Get.offAllNamed('/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'شروع بازی',
                        style: TextStyle(
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
}

// ============================================================
// 🏠 صفحه اصلی (نقشه)
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int money = 0;
  int perSecond = 1;

  @override
  void initState() {
    super.initState();
    _startIncome();
  }

  void _startIncome() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
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
        child: Stack(
          children: [
            // پس‌زمینه آبشار
            Positioned.fill(
              child: ImageHelper.load(
                path: 'assets/images/waterfall.png',
                fallbackEmoji: '🏞️',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // لایه تاریک روی پس‌زمینه
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

            // نوار بالا (پول)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildTopBar(),
            ),

            // دکمه خونه (بالا چپ)
            Positioned(
              top: 120,
              left: 20,
              child: _mapButton('خونه', '🏠', () {
                Get.snackbar(
                  'خونه',
                  '۷۵ کیلومتر تا اینجا...',
                  backgroundColor: AppTheme.darkCard,
                  colorText: Colors.white,
                );
              }),
            ),

            // دکمه حاج آقا (بالا راست)
            Positioned(
              top: 120,
              right: 20,
              child: _mapButton('حاج آقا', '👴', () {
                Get.snackbar(
                  'حاج آقا',
                  'رقیب قدیمی...',
                  backgroundColor: AppTheme.darkCard,
                  colorText: Colors.white,
                );
              }),
            ),

            // دکان ممد (وسط)
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => money += 10),
                  child: ImageHelper.load(
                    path: 'assets/images/boofe.png',
                    fallbackEmoji: '🏪',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),

            // دکمه جاده (پایین چپ)
            Positioned(
              bottom: 180,
              left: 20,
              child: _mapButton('جاده', '🚗', () {
                Get.snackbar(
                  'جاده',
                  '۷۵ کیلومتر...',
                  backgroundColor: AppTheme.darkCard,
                  colorText: Colors.white,
                );
              }),
            ),

            // دکمه ماشین (پایین راست)
            Positioned(
              bottom: 180,
              right: 20,
              child: _mapButton('ماشین', '🚙', () {
                Get.snackbar(
                  'پیکان',
                  'ماشین قدیمی...',
                  backgroundColor: AppTheme.darkCard,
                  colorText: Colors.white,
                );
              }),
            ),

            // دکمه‌ها (پایین)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildButtons(),
            ),
          ],
        ),
      ),
    );
  }

  // ====== نوار بالا ======
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
                '$money تومن',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '+$perSecond تومن/ثانیه',
                style: const TextStyle(
                  color: AppTheme.green,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const Icon(Icons.star, color: AppTheme.gold, size: 24),
        ],
      ),
    );
  }

  // ====== دکمه نقشه ======
  Widget _mapButton(String label, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.gold),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ====== دکمه‌های پایین ======
  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _menuButton('داستان', '📖', () => Get.offAllNamed('/story')),
          _menuButton('ارتقا', '🔼', () => Get.toNamed('/upgrade')),
          _menuButton('رقیب', '👴', () {
            Get.snackbar(
              'حاج آقا',
              'رقیب قدیمی شهر...',
              backgroundColor: AppTheme.darkCard,
              colorText: Colors.white,
            );
          }),
        ],
      ),
    );
  }

  Widget _menuButton(String label, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.blue),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
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
      {
        'name': 'بوفه چوبی',
        'price': 'رایگان',
        'income': '۱ تومن/ثانیه',
        'emoji': '🏪',
        'image': 'boofe.png',
        'level': 1,
      },
      {
        'name': 'چای‌خانه',
        'price': '۵۰۰',
        'income': '۵ تومن/ثانیه',
        'emoji': '☕',
        'image': 'chai_khane.png',
        'level': 0,
      },
      {
        'name': 'بستنی‌فروشی',
        'price': '۵,۰۰۰',
        'income': '۲۵ تومن/ثانیه',
        'emoji': '🍦',
        'image': 'bastani.png',
        'level': 0,
      },
      {
        'name': 'ساندویچی',
        'price': '۵۰,۰۰۰',
        'income': '۱۵۰ تومن/ثانیه',
        'emoji': '🥪',
        'image': 'sandwichi.png',
        'level': 0,
      },
      {
        'name': 'رستوران آبشار',
        'price': '۱,۰۰۰,۰۰۰',
        'income': '۱,۰۰۰ تومن/ثانیه',
        'emoji': '🍽️',
        'image': 'restaurant.png',
        'level': 0,
      },
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
          final isOwned = (b['level'] as int) > 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isOwned ? AppTheme.green : Colors.grey.shade700,
                width: isOwned ? 2 : 1,
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
                          if (isOwned) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'خریداری شده',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'درآمد: ${b['income']}',
                        style: const TextStyle(
                          color: AppTheme.green,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'قیمت: ${b['price']} تومن',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      b['name'] as String,
                      isOwned ? 'ارتقا' : 'خرید',
                      backgroundColor: AppTheme.darkCard,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOwned ? AppTheme.green : AppTheme.blue,
                  ),
                  child: Text(isOwned ? 'ارتقا' : 'خرید'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}