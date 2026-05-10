import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Widget untuk menampilkan chart/grafik tasks completed per hari
class ChartWidget extends StatelessWidget {
  final Map<String, int> completedTasksPerDate;

  const ChartWidget({
    super.key,
    required this.completedTasksPerDate,
  });

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada data, tampilkan pesan
    if (completedTasksPerDate.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'Belum ada tugas yang diselesaikan',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Ambil data terakhir 7 hari
    final dates = completedTasksPerDate.keys.toList();
    final counts = completedTasksPerDate.values.toList();

    // Batasi maksimal 7 hari
    final displayDates = dates.length > 7 ? dates.sublist(dates.length - 7) : dates;
    final displayCounts =
        counts.length > 7 ? counts.sublist(counts.length - 7) : counts;

    // Buat bar chart data
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < displayDates.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: displayCounts[i].toDouble(),
              color: const Color(0xFF2BA08D),
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TUGAS SELESAI / HARI (BONUS)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < displayDates.length) {
                          final date = displayDates[index].split('-');
                          return Text(
                            date.length >= 2 ? date[2] : '',
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
