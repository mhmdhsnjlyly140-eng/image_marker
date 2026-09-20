import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  bool _loading = false;

  Future<void> _generate() async {
    if (_controller.text.isEmpty) return;
    setState(() => _loading = true);
    final seed = Random().nextInt(999999);
    final prompt = Uri.encodeComponent(_controller.text);
    final url = 'https://image.pollinations.ai/prompt/$prompt?seed=$seed&nologo=true';
    setState(() {
      _imageUrl = url;
      _loading = false;
    });
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
            ElevatedButton(
              onPressed: _loading ? null : _generate,
              child: Text(_loading ? 'در حال ساخت...' : 'بساز!'),
            ),
            const SizedBox(height: 20),
            if (_imageUrl != null)
              Expanded(
                child: Image.network(_imageUrl!, fit: BoxFit.contain),
              ),
          ],
        ),
      ),
    );
  }
}
