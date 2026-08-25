import 'package:flutter/material.dart';

class MathView extends StatelessWidget {
  final String tex;
  final TextStyle? textStyle;

  const MathView({
    super.key,
    required this.tex,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Format TeX math string to readable formatted display string
    final formattedText = _formatTex(tex);
    final defaultStyle = textStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'serif',
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        formattedText,
        textAlign: TextAlign.center,
        style: defaultStyle,
      ),
    );
  }

  String _formatTex(String rawTex) {
    return rawTex
        .replaceAll(r'\int_{0}^{\pi}', '∫₀^π')
        .replaceAll(r'\int_{0}^{\frac{\pi}{2}}', '∫₀^(π/2)')
        .replaceAll(r'\int', '∫')
        .replaceAll(r'\cdot', ' • ')
        .replaceAll(r'\sin', 'sin')
        .replaceAll(r'\cos', 'cos')
        .replaceAll(r'\pi', 'π')
        .replaceAll(r'\, dx', ' dx')
        .replaceAll(r'dx', ' dx')
        .replaceAll(r'\vec{F}', 'F⃗')
        .replaceAll(r'\vec{a}', 'a⃗')
        .replaceAll(r'\, dv', ' dv')
        .replaceAll(r'\, du', ' du');
  }
}
