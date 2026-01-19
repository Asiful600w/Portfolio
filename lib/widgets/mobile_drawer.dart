import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/styles.dart';

class MobileDrawer extends StatelessWidget {
  final VoidCallback? onHomeClick;
  final VoidCallback? onProjectsClick;
  final VoidCallback? onAboutClick;
  final VoidCallback? onServicesClick;
  final VoidCallback? onContactClick;

  const MobileDrawer({
    super.key,
    this.onHomeClick,
    this.onProjectsClick,
    this.onAboutClick,
    this.onServicesClick,
    this.onContactClick,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundDark.withValues(alpha: 0.8),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Close Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Logo(),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ).animate().fadeIn(duration: 400.ms),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _DrawerItem(
                      title: "Home",
                      icon: Icons.home_outlined,
                      index: 0,
                      onTap: () {
                        Navigator.pop(context);
                        onHomeClick?.call();
                      },
                    ),
                    _DrawerItem(
                      title: "Projects",
                      icon: Icons.grid_view,
                      index: 1,
                      onTap: () {
                        Navigator.pop(context);
                        onProjectsClick?.call();
                      },
                    ),
                    _DrawerItem(
                      title: "About",
                      icon: Icons.person_outline,
                      index: 2,
                      onTap: () {
                        Navigator.pop(context);
                        onAboutClick?.call();
                      },
                    ),
                    _DrawerItem(
                      title: "Services",
                      icon: Icons.design_services_outlined,
                      index: 3,
                      onTap: () {
                        Navigator.pop(context);
                        onServicesClick?.call();
                      },
                    ),
                  ],
                ),
              ),

              // Bottom Section (Contact)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onContactClick?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "CONTACT ME",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
                    const SizedBox(height: 24),
                    Text(
                      "© 2026 ASIFUL ISLAM",
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        color: Colors.grey[600],
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 20),
              Text(
                title,
                style: AppTextStyles.heroSubtitle.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.grey.withValues(alpha: 0.3), size: 16),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (200 + (index * 100)).ms)
        .slideX(begin: -0.1, duration: 400.ms);
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.terminal, color: AppColors.primary),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: 'Asifs',
            style: AppTextStyles.display.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: const [
              TextSpan(
                text: 'Portfolio',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
