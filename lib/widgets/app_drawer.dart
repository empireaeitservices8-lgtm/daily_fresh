import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../providers/app_state.dart';
import '../screens/submitted_tasks_screen.dart';
import '../theme/app_theme.dart';
import 'dayfresh_logo.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onNavigate;
  final AppState? state;

  const AppDrawer({super.key, required this.onNavigate, this.state});

  @override
  Widget build(BuildContext context) {
    final user = state?.currentUser;
    final userName = user?.name ?? 'Juan Martinez';
    final userRole = user?.role ?? 'Store Operations Lead';
    final userBranch = user?.storeBranch ?? 'Store #104';
    final userInitials = user?.initials ?? 'JM';

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DayFreshLogo(scale: 1.1),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Text(
                        userInitials,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$userRole • $userBranch',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 5,
                            runSpacing: 4,
                            children: [
                              _buildRoleBadge(
                                context,
                                'Staff',
                                UserRole.staff,
                                (state?.currentUser.userRole ?? UserRole.staff) == UserRole.staff,
                                const Color(0xFF16A34A),
                              ),
                              _buildRoleBadge(
                                context,
                                'SM (Store)',
                                UserRole.storeManager,
                                state?.currentUser.userRole == UserRole.storeManager,
                                const Color(0xFF2563EB),
                              ),
                              _buildRoleBadge(
                                context,
                                'GM (HQ)',
                                UserRole.generalManager,
                                state?.currentUser.userRole == UserRole.generalManager,
                                const Color(0xFFD97706),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assignment_rounded,
                  title: 'Task Management',
                  badge: '5 Pending',
                  badgeColor: AppColors.priorityHighBg,
                  badgeTextColor: AppColors.priorityHighText,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(1);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.task_alt_rounded,
                  title: 'Submitted Tasks',
                  badge: '${state?.submittedTasksCount ?? 7} Done',
                  badgeColor: AppColors.statusCompletedBg,
                  badgeTextColor: AppColors.statusCompletedText,
                  onTap: () {
                    Navigator.pop(context);
                    if (state != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubmittedTasksScreen(state: state!),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.fact_check_rounded,
                  title: 'Store Checklist',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(2);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.storefront_rounded,
                  title: 'Sections & Aisle View',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(3);
                  },
                ),
                const Divider(height: 24, thickness: 1, indent: 20, endIndent: 20),
                _buildDrawerItem(
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'Barcode / SKU Scanner',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SKU Barcode Scanner activated')),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bar_chart_rounded,
                  title: 'Analytics & Compliance',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Preferences & Store Setup',
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(4);
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.pop(context);
                    state?.logout();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.logout_rounded, color: AppColors.priorityHighText, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.priorityHighText,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'v2.4.1',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? badge,
    Color? badgeColor,
    Color? badgeTextColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen, size: 22),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: badgeTextColor ?? AppColors.primaryGreen,
                ),
              ),
            )
          : const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildRoleBadge(
    BuildContext context,
    String label,
    UserRole role,
    bool isSelected,
    Color activeColor,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        state?.switchUserRole(role);
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.white70 : Colors.white24,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
