import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/db_helper.dart';
import '../utils/constants.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  late final DatabaseHelper _db;
  int _completedCount = 0;
  int _incompleteCount = 0;
  Map<String, int> _completedPerDay = {};

  @override
  void initState() {
    super.initState();
    _db = DatabaseHelper();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final completed = await _db.countCompletedTasks();
    final incomplete = await _db.countIncompleteTasks();
    final perDay = await _db.getCompletedTasksPerDate();

    if (!mounted) {
      return;
    }

    setState(() {
      _completedCount = completed;
      _incompleteCount = incomplete;
      _completedPerDay = perDay;
    });
  }

  Future<void> _refreshStats() async {
    await _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateText = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now).toUpperCase();
    final weeklyCounts = _buildWeeklyCounts(now, _completedPerDay);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                const Text(
                  'Halo, Selamat Pagi!',
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0E43A1),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                    color: Colors.black.withValues(alpha: 0.74),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _StatPreviewCard(
                        accentColor: const Color(0xFF1B8A3C),
                        icon: Icons.check_circle_outline,
                        badgeText: '+12%',
                        badgeColor: const Color(0xFFE4F0E8),
                        badgeTextColor: const Color(0xFF1B8A3C),
                        title: 'Completed Tasks',
                        value: _completedCount.toString(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatPreviewCard(
                        accentColor: const Color(0xFF0F46B8),
                        icon: Icons.pending_actions_outlined,
                        badgeText: 'Active',
                        badgeColor: const Color(0xFFE7EEFF),
                        badgeTextColor: const Color(0xFF0F46B8),
                        title: 'Pending Tasks',
                        value: _incompleteCount.toString().padLeft(2, '0'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(builder: (context, constraints) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Grafik Produktivitas',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.4),
                              child: const Text(
                                'Ikhtisar Mingguan',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 170,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(7, (index) {
                            final count = weeklyCounts[index];
                            final maxCount = weeklyCounts.fold<int>(0, (value, element) => element > value ? element : value);
                            final heightFactor = maxCount == 0 ? 0.24 : (0.24 + ((count / maxCount) * 0.76));
                            final barColor = _weeklyBarColor(index);

                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: index == 0 ? 0 : 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                      height: 128 * heightFactor,
                                      decoration: BoxDecoration(
                                        color: barColor,
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _WeekLabel('SEN'),
                          _WeekLabel('SEL'),
                          _WeekLabel('RAB'),
                          _WeekLabel('KAM'),
                          _WeekLabel('JUM'),
                          _WeekLabel('SAB'),
                          _WeekLabel('MIN'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  // calculate tile height and aspect ratio to keep tiles reasonably sized on small screens
                  final spacing = 16.0;
                  final crossCount = 2;
                  final tileWidth = (totalWidth - (spacing * (crossCount - 1))) / crossCount;
                  final tileHeight = 140.0; // desired tile height
                  final childAspectRatio = tileWidth / tileHeight;

                  return GridView.count(
                    crossAxisCount: crossCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: childAspectRatio,
                    children: [
                    _ActionTile(
                      backgroundColor: const Color(0xFFFFF4F4),
                      borderColor: const Color(0xFFF1D3D3),
                      iconBackground: const Color(0xFFD32020),
                      icon: Icons.priority_high,
                      iconColor: Colors.white,
                      label: 'Add Important\nTask',
                      labelColor: const Color(0xFFA41717),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppConstants.ROUTE_TAMBAH_PENTING)
                            .then((_) => _refreshStats());
                      },
                    ),
                    _ActionTile(
                      backgroundColor: const Color(0xFFE7FAEC),
                      borderColor: const Color(0xFFD1F0D9),
                      iconBackground: const Color(0xFF0C7B33),
                      icon: Icons.add,
                      iconColor: Colors.white,
                      label: 'Add Normal Task',
                      labelColor: const Color(0xFF13703A),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppConstants.ROUTE_TAMBAH_BIASA)
                            .then((_) => _refreshStats());
                      },
                    ),
                    _ActionTile(
                      backgroundColor: const Color(0xFFE1EAFD),
                      borderColor: const Color(0xFFC8D6FA),
                      iconBackground: const Color(0xFF0F46B8),
                      icon: Icons.checklist,
                      iconColor: Colors.white,
                      label: 'Task List',
                      labelColor: const Color(0xFF0F46B8),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppConstants.ROUTE_DAFTAR)
                            .then((_) => _refreshStats());
                      },
                    ),
                    _ActionTile(
                      backgroundColor: const Color(0xFFE9EAF2),
                      borderColor: const Color(0xFFD9DAE6),
                      iconBackground: const Color(0xFF7A7F92),
                      icon: Icons.settings,
                      iconColor: Colors.white,
                      label: 'Settings',
                      labelColor: const Color(0xFF41475A),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppConstants.ROUTE_SETTINGS);
                      },
                    ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipPath(
      clipper: _HeaderWaveClipper(),
      child: Container(
        height: 140,
        color: const Color(0xFF0E43A1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Agenda Nusantara',
                style: const TextStyle(
                  fontSize: 28,
                  height: 1.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<int> _buildWeeklyCounts(DateTime now, Map<String, int> completedPerDay) {
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List<int>.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      final key = DateFormat('yyyy-MM-dd').format(date);
      return completedPerDay[key] ?? 0;
    });
  }

  Color _weeklyBarColor(int index) {
    const colors = [
      Color(0xFFAAB9E3),
      Color(0xFF8EA4D8),
      Color(0xFFC0CAEA),
      Color(0xFF0E43A1),
      Color(0xFF6482C0),
      Color(0xFF3566B9),
      Color(0xFF9DB0DB),
    ];

    return colors[index % colors.length];
  }
}

class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height - 20);
    path.quadraticBezierTo(size.width * 0.75, size.height - 40, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _StatPreviewCard extends StatelessWidget {
  const _StatPreviewCard({
    required this.accentColor,
    required this.icon,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.title,
    required this.value,
  });

  final Color accentColor;
  final IconData icon;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border(left: BorderSide(color: accentColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 34, color: accentColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.76),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 50,
              height: 1.0,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackground,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color iconBackground;
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconBackground.withValues(alpha: 0.20),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(height: 18),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekLabel extends StatelessWidget {
  const _WeekLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6B7280),
        letterSpacing: 0.8,
      ),
    );
  }
}
