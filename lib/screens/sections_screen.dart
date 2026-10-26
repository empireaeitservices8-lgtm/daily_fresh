import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/notification_button.dart';
import 'display_management_screen.dart';

class StoreSection {
  final String name;
  final String code;
  final String supervisor;
  final int totalSkus;
  final double complianceRate;
  final IconData icon;
  final Color accentColor;

  StoreSection({
    required this.name,
    required this.code,
    required this.supervisor,
    required this.totalSkus,
    required this.complianceRate,
    required this.icon,
    required this.accentColor,
  });
}

class SectionsScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenDrawer;

  const SectionsScreen({
    super.key,
    required this.state,
    required this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      StoreSection(
        name: 'Fresh Produce',
        code: 'SEC-01',
        supervisor: 'Maria Santos',
        totalSkus: 420,
        complianceRate: 0.94,
        icon: Icons.eco_rounded,
        accentColor: const Color(0xFF16A34A),
      ),
      StoreSection(
        name: 'Dairy & Chilled Foods',
        code: 'SEC-02',
        supervisor: 'Ahmed Khan',
        totalSkus: 680,
        complianceRate: 0.88,
        icon: Icons.egg_alt_rounded,
        accentColor: const Color(0xFF0284C7),
      ),
      StoreSection(
        name: 'Meat & Seafood',
        code: 'SEC-03',
        supervisor: 'Carlos Gomez',
        totalSkus: 310,
        complianceRate: 0.97,
        icon: Icons.restaurant_rounded,
        accentColor: const Color(0xFFDC2626),
      ),
      StoreSection(
        name: 'Bakery & Confectionery',
        code: 'SEC-04',
        supervisor: 'Elena Rostova',
        totalSkus: 240,
        complianceRate: 0.91,
        icon: Icons.bakery_dining_rounded,
        accentColor: const Color(0xFFD97706),
      ),
      StoreSection(
        name: 'Dry Grocery & Beverages',
        code: 'SEC-05',
        supervisor: 'David Chen',
        totalSkus: 1850,
        complianceRate: 0.85,
        icon: Icons.local_grocery_store_rounded,
        accentColor: const Color(0xFF7C3AED),
      ),
      StoreSection(
        name: 'Household & Personal Care',
        code: 'SEC-06',
        supervisor: 'Priya Sharma',
        totalSkus: 920,
        complianceRate: 0.96,
        icon: Icons.cleaning_services_rounded,
        accentColor: const Color(0xFF0D9488),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          onPressed: onOpenDrawer,
        ),
        title: Text(
          'Store Sections',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          NotificationBellButton(
            count: state.unreadNotifications,
            onTap: () => state.clearNotifications(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Module 8: Daily Display Management Action Card
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0C5D37), Color(0xFF147A49)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0C5D37).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storefront_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Module 8: Display Updates',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '10:00 AM Deadline',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFDE68A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload photos of department displays and FEFO arrangements daily before 10:00 AM to avoid Arears.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const DisplayManagementScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Open Display Management',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Text(
            'Store Department Sections',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          ...sections.map((s) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const DisplayManagementScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: s.accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(s.icon, color: s.accentColor, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  s.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  s.code,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Supervisor: ${s.supervisor} • ${s.totalSkus} SKUs',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(s.complianceRate * 100).toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: s.complianceRate >= 0.9
                                ? AppColors.statSubmitted
                                : AppColors.statPending,
                          ),
                        ),
                        Text(
                          'Audit Score',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
