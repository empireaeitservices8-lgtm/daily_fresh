import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dayfresh_logo.dart';
import 'display_management_screen.dart';
import 'registers_screen.dart';

class MoreScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenDrawer;

  const MoreScreen({
    super.key,
    required this.state,
    required this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context) {
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
          'More & Profile',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
                    child: Text(
                      state.currentUser.initials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.currentUser.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.currentUser.role,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.statusCompletedBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${state.currentUser.employeeId} • On Shift',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.statusCompletedText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Store Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branch & Contact Details',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBranchInfoItem(Icons.storefront_rounded, 'Branch', state.currentUser.storeBranch),
                  _buildBranchInfoItem(Icons.phone_android_rounded, 'Verified Phone (OTP)', state.currentUser.phone),
                  _buildBranchInfoItem(Icons.schedule_rounded, 'Store Hours', '07:00 AM - 11:00 PM'),
                  _buildBranchInfoItem(Icons.dns_rounded, 'POS Terminal Sync', 'Online • Synced 2m ago'),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Quick App Actions
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  _buildActionTile(Icons.fact_check_rounded, 'Module 9: Sections Registers Updates', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const RegistersScreen(),
                      ),
                    );
                  }),
                  const Divider(height: 1, indent: 56),
                  _buildActionTile(Icons.storefront_rounded, 'Module 8: Daily Display Management', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const DisplayManagementScreen(),
                      ),
                    );
                  }),
                  const Divider(height: 1, indent: 56),
                  _buildActionTile(Icons.history_rounded, 'Task Submission History', () {
                    state.setNavIndex(1);
                  }),
                  const Divider(height: 1, indent: 56),
                  _buildActionTile(Icons.menu_book_rounded, 'Operations SOP & Manual', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Operations SOP Manual v3.2')),
                    );
                  }),
                  const Divider(height: 1, indent: 56),
                  _buildActionTile(Icons.cloud_sync_rounded, 'Sync Local Audits with HQ', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All local audits synced with HQ Server')),
                    );
                  }),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppColors.priorityHighText, size: 22),
                    title: Text(
                      'Log Out / Switch Account',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.priorityHighText,
                      ),
                    ),
                    subtitle: Text(
                      'Return to mobile number login screen',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.priorityHighText, size: 20),
                    onTap: () {
                      state.logout();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // DayFresh brand footer
            const DayFreshLogo(scale: 0.9, isDarkBackground: false),
            const SizedBox(height: 8),
            Text(
              'Hypermarket Retail Operations Platform\nVersion 2.4.1 (Build 820)',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.textLight,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
              ),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen, size: 22),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
      onTap: onTap,
    );
  }
}
