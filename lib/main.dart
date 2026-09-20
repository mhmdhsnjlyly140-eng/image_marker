import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String? _imageUrl;

  void _generate() {
    if (_controller.text.isEmpty) return;
    final seed = Random().nextInt(999999);
    final prompt = Uri.encodeComponent(_controller.text);
    setState(() {
      _imageUrl = 'https://image.pollinations.ai/prompt/$prompt?seed=$seed&nologo=true&width=768&height=768';
    });
  }

  void _retry() {
    _generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Maker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'توضیح عکس رو بنویس...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _generate,
                  child: const Text('بساز!'),
                ),
                const SizedBox(width: 12),
                if (_imageUrl != null)
                  OutlinedButton(
                    onPressed: _retry,
                    child: const Text('دوباره'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (_imageUrl != null)
              Expanded(
                child: Image.network(
                  _imageUrl!,
                  fit: BoxFit.contain,
                  loadingBuilder: (c, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (c, e, s) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('عکس لود نشد 😕'),
                          const SizedBox(height: 8),
                          const Text('شاید اینترنت یا فیلتر مشکل داره'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _retry,
                            child: const Text('دوباره امتحان کن'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}