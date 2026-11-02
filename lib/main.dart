import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const PixeloraApp());

class PixeloraApp extends StatelessWidget {
  const PixeloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixelora AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7657E8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F6FC),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  int _freeCredits = 3;
  bool _isProcessing = false;
  String _status = 'Choose a photo to get started';

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDay = prefs.getString('credit_day');
    if (savedDay != today) {
      await prefs.setString('credit_day', today);
      await prefs.setInt('free_credits', 3);
    }
    if (!mounted) return;
    setState(() => _freeCredits = prefs.getInt('free_credits') ?? 3);
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );
    if (file == null) return;
    setState(() {
      _selectedImage = File(file.path);
      _status = 'Photo selected. Choose an editing tool below.';
    });
  }

  Future<void> _useFreeCredit() async {
    if (_selectedImage == null) {
      setState(() => _status = 'Please select a photo first.');
      return;
    }
    if (_freeCredits <= 0) {
      _showPremiumDialog();
      return;
    }
    setState(() {
      _isProcessing = true;
      _status = 'AI editing connection will be enabled after API setup.';
    });

    // Production integration:
    // Send the image to your own secure backend endpoint.
    // Do NOT place a private AI API key inside this Android app.
    await Future.delayed(const Duration(milliseconds: 700));

    final prefs = await SharedPreferences.getInstance();
    final next = _freeCredits - 1;
    await prefs.setInt('free_credits', next);
    if (!mounted) return;
    setState(() {
      _freeCredits = next;
      _isProcessing = false;
      _status = 'Demo mode: connect the AI backend to remove the background.';
    });
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Daily free edits used'),
        content: const Text(
          'You have used your 3 demo credits for today. '
          'Premium purchases will be connected before public release.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _toolCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAE7F4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF0ECFF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: const Color(0xFF7657E8)),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pixelora AI',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_freeCredits free edits',
                  style: const TextStyle(
                    color: Color(0xFF6244D5),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7657E8), Color(0xFF4832A7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Make every photo\\nlook professional.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Simple editing for personal photos, social media and products.',
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _pickImage,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF563DB8),
                    ),
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Choose a photo'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (_selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  _selectedImage!,
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 120,
                    child: Center(child: Text('Unable to preview this image')),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: _isProcessing ? null : _useFreeCredit,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_fix_high),
                label: Text(
                  _isProcessing ? 'Please wait...' : 'Remove background (AI)',
                ),
              ),
              const SizedBox(height: 8),
              Text(_status, textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              const SizedBox(height: 18),
            ],
            const Text(
              'Choose your editing tool',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.22,
              children: [
                _toolCard(Icons.person_remove_alt_1, 'Background Remover',
                    'Cut out your subject', _pickImage),
                _toolCard(Icons.wallpaper_outlined, 'Background Changer',
                    'Choose a new backdrop', _pickImage),
                _toolCard(Icons.crop, 'Crop & Resize',
                    'Fit any format', _pickImage),
                _toolCard(Icons.storefront_outlined, 'Product Photos',
                    'For online stores', _pickImage),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFEAE7F4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium,
                      color: Color(0xFF7657E8), size: 30),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pixelora Premium',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        SizedBox(height: 3),
                        Text('More edits and extra creative tools',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showPremiumDialog,
                    child: const Text('Explore'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Prototype preview • AI processing, ads and payments are not live yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
