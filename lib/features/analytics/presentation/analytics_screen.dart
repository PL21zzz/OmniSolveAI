import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:omni_solve_ai/app/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê Năng lực & Tiến độ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Performance Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Tổng bài đã giải',
                    value: '42 bài',
                    subtitle: '+12% so với tuần trước',
                    icon: Icons.check_circle_rounded,
                    color: primaryColor,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Tỉ lệ làm đúng',
                    value: '88.5%',
                    subtitle: 'Tăng 4.2% độ chính xác',
                    icon: Icons.trending_up_rounded,
                    color: Colors.green,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly Solved Chart Section
            Text('Thời lượng học trong tuần (Giờ)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                ),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchDataEnabled(false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[value.toInt() % days.length],
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBarGroup(0, 4.5, primaryColor),
                    _buildBarGroup(1, 7.0, primaryColor),
                    _buildBarGroup(2, 3.5, primaryColor),
                    _buildBarGroup(3, 8.5, primaryColor),
                    _buildBarGroup(4, 6.0, primaryColor),
                    _buildBarGroup(5, 9.0, primaryColor),
                    _buildBarGroup(6, 5.0, primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Subject Mastery Breakdown
            Text('Độ thành thạo theo môn học', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildMasteryItem(context, subject: 'Giải Tích & Đại Số', progress: 0.88, color: primaryColor, isDark: isDark),
            _buildMasteryItem(context, subject: 'Vật Lý Đại Cương', progress: 0.74, color: const Color(0FF6366F1), isDark: isDark),
            _buildMasteryItem(context, subject: 'Hóa Học Đại Cương', progress: 0.62, color: Colors.orangeAccent, isDark: isDark),
            _buildMasteryItem(context, subject: 'Lập Trình & Cấu Trúc Dữ Liệu', progress: 0.92, color: Colors.green, isDark: isDark),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMasteryItem(
    BuildContext context, {
    required String subject,
    required double progress,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${(progress * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
