import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';
import 'package:omni_solve_ai/features/scanner/data/gemini_service.dart';
import 'package:omni_solve_ai/features/scanner/presentation/solution_detail_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;
  String _selectedSubject = 'Tiếng Anh';

  final List<String> _subjects = ['Toán học', 'Vật Lý', 'Hóa Học', 'Tiếng Anh'];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
        );
      }
    }
  }

  Future<void> _analyzeWithAI([String? customSubject]) async {
    final targetSubject = customSubject ?? _selectedSubject;

    setState(() {
      _isLoading = true;
    });

    try {
      final service = GeminiService();
      final result = await service.analyzeProblemImage(
        _selectedImageBytes ?? Uint8List(0),
        selectedSubject: targetSubject,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SolutionDetailScreen(result: result),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể kết nối AI: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chẩn đoán Lỗi sai AI (4 Môn)'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4-Subject Filter Pills with Horizontal Scroll (Fixes 4.0px Right Overflow!)
            Text('Chọn môn học chẩn đoán:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _subjects.map((subj) {
                  final isSelected = subj == _selectedSubject;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(subj),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedSubject = subj;
                          });
                        }
                      },
                      selectedColor: primaryColor.withValues(alpha: 0.25),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? primaryColor : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Image Preview / Scanner View Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                  ),
                ),
                child: _selectedImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                            Container(
                              color: Colors.black38,
                              child: Center(
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: primaryColor, width: 3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.center_focus_strong, color: Colors.white, size: 40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: primaryColor.withValues(alpha: 0.15),
                            child: Icon(Icons.document_scanner_rounded, color: primaryColor, size: 34),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Chẩn đoán lỗi sai môn $_selectedSubject',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Chụp ảnh hoặc chọn 1 bài tập mẫu bên dưới để test',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Preset Sample Buttons for LDPlayer Testing
            Text('Test nhanh trên LDPlayer (Bài mẫu 4 môn):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetButton('📐 Bài Toán mẫu', 'Toán học', primaryColor),
                  const SizedBox(width: 8),
                  _buildPresetButton('⚡ Bài Lý mẫu', 'Vật Lý', const Color(0xFF6366F1)),
                  const SizedBox(width: 8),
                  _buildPresetButton('🧪 Bài Hóa mẫu', 'Hóa Học', Colors.orangeAccent),
                  const SizedBox(width: 8),
                  _buildPresetButton('🇬🇧 Bài Tiếng Anh mẫu', 'Tiếng Anh', Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Upload & Analyze Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded, size: 18),
                    label: const Text('Chọn từ máy'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _analyzeWithAI(),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: Text(_isLoading ? 'Đang chẩn đoán...' : 'Chẩn đoán $_selectedSubject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(String label, String subject, Color color) {
    return ActionChip(
      avatar: Icon(Icons.play_arrow_rounded, color: color, size: 16),
      label: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
      backgroundColor: color.withValues(alpha: 0.12),
      onPressed: () {
        setState(() {
          _selectedSubject = subject;
        });
        _analyzeWithAI(subject);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
