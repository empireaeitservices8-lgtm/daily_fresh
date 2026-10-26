import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DayFreshBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final bool isGeneralManager;
  final bool isStoreManager;

  const DayFreshBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.isGeneralManager = false,
    this.isStoreManager = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: isGeneralManager
                    ? Icons.admin_panel_settings_outlined
                    : isStoreManager
                        ? Icons.storefront_outlined
                        : Icons.home_outlined,
                activeIcon: isGeneralManager
                    ? Icons.admin_panel_settings_rounded
                    : isStoreManager
                        ? Icons.storefront_rounded
                        : Icons.home_rounded,
                label: isGeneralManager
                    ? 'GM Hub'
                    : isStoreManager
                        ? 'SM Hub'
                        : 'Dashboard',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment_rounded,
                label: 'Tasks',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.checklist_rtl_rounded,
                activeIcon: Icons.checklist_rounded,
                label: 'Checklist',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.storefront_outlined,
                activeIcon: Icons.storefront_rounded,
                label: 'Sections',
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.more_horiz_rounded,
                activeIcon: Icons.more_horiz_rounded,
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.navBarActivePill : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
