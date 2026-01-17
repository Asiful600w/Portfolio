import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/styles.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false;

  final List<_ProjectData> _projects = [
    _ProjectData(
      title: "CryptoVault",
      subtitle: "Secure DeFi Wallet & Exchange Dashboard",
      image:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCYk43iWw7mU-aaIRj5F-1KKHAlVnqmf9kgND6fhlvmJtpPpb3RUVkU4JUM8vGruDFOO3ZB8AR92P-V3KYvFxqf67X5ll-YIjKA8rOCxsLlI4kNiWlJskmtRyQIc1cGHqrhqCQA8Vmow6BEQbeCxpQaurgslVtWcCb7s8R55k8t5tmXW6rG4xx6vchGh-VjpQs8u2DiryGKkx5HmJYs-GcKL7y97g84s2x3uCX9GYziJmOVperCDYbIRWVdFHvgEUrIVh-ALYhTp0PI",
      tags: ["Flutter", "Dart", "Firebase"],
      version: "V 2.4.0",
      updated: "UPDATED 2D AGO",
      isLive: true,
    ),
    _ProjectData(
      title: "Nexus Home",
      subtitle: "Centralized IoT Control Hub",
      image:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuAhsN8Y8aa4HoZseBFgj5IPxXqlpFcHwi3qUK7LQQHllgYoshDUrKcLryG2q8nQZTHDgP0VR40lpNjIYyg-Rm3ZRjwK8jrhld8nCUH7WR9XpJdFXRFsOMXN8GK2zjvelmG4DRzBmTq-IMMH-ofOqGcWJ_w0Ed42A3JbaIFE0yJ01Oq5lfHqnZ5THo8eA6EZe71QpJHqj1_6Dy6hb_bU8VpGu-M5B8TcuDSFUj1dq6kSiaODt206CJ3Hd6XZ17DvTB-6Gn6CNXnSyvpW",
      tags: ["Flutter", "IoT / MQTT", "Bluetooth LE"],
      version: "V 1.1.0",
      updated: "HARDWARE INTEGRATED",
      isLive: false,
    ),
    _ProjectData(
      title: "Vogue Market",
      subtitle: "High-End Fashion Retail Application",
      image:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCNEVmun3YgvpMTrQdIps0qCjkSHiybdBGYGZ6b85bf5Ey1I7WmYAKyPmVPsUIngbK__4s_lujJ93p43ukY6v-0j69RGlXThZYxKOHZkNeNSN8zq8JGLShR15PxP4NKuMORKoQdy5IpgXv1e8zW2DVUv6HM3D2XnSbbR5Jy2uXdVuAmgBOSSjFBB4AqkEOmTkkELtpjlVVNEC82AHxzqVJdQIbrxBYgIDTf5WkQd6cirNHHoJ8Fo_3iHeHoal0Z0qYWrIO_4PZsV67N",
      tags: ["Stripe API", "Riverpod"],
      version: "BETA",
      updated: "50K+ USERS",
      isLive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('projects_section_visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _SectionHeader(
                onPrev: () => _scrollController.animateTo(
                  _scrollController.offset - 400,
                  duration: 500.ms,
                  curve: Curves.easeOut,
                ),
                onNext: () => _scrollController.animateTo(
                  _scrollController.offset + 400,
                  duration: 500.ms,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Carousel
            SizedBox(
              height: 560,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _projects.length,
                separatorBuilder: (_, __) => const SizedBox(width: 32),
                itemBuilder: (context, index) {
                  return _ProjectCard(
                    project: _projects[index],
                    index: index,
                    isVisible: _isVisible,
                  );
                },
              ),
            ),

            // Footer Hint
            const SizedBox(height: 32),
            const _FooterHint(),
          ],
        ),
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String subtitle;
  final String image;
  final List<String> tags;
  final String version;
  final String updated;
  final bool isLive;

  _ProjectData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.tags,
    required this.version,
    required this.updated,
    required this.isLive,
  });
}

class _SectionHeader extends StatelessWidget {
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _SectionHeader({required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 1,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "DEPLOYMENTS",
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: 48,
                      height: 1.1,
                    ),
                    children: [
                      const TextSpan(text: "Selected "),
                      TextSpan(
                        text: "Works",
                        style: TextStyle(
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF4D4DFF)],
                            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Buttons (Hidden on mobile usually, but kept for responsiveness)
          Row(
            children: [
              _NavButton(icon: Icons.arrow_back, onTap: onPrev),
              const SizedBox(width: 16),
              _NavButton(icon: Icons.arrow_forward, onTap: onNext),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final _ProjectData project;
  final int index;
  final bool isVisible;

  const _ProjectCard({
    required this.project,
    required this.index,
    required this.isVisible,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final cardWidth = isMobile
        ? MediaQuery.of(context).size.width * 0.85
        : 600.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child:
          AnimatedContainer(
                duration: 300.ms,
                width: cardWidth,
                transform: Matrix4.identity()
                  ..translate(0.0, _isHovered ? -10.0 : 0.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2124).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? AppColors.primary
                        : Colors.white.withOpacity(0.1),
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      Stack(
                        children: [
                          SizedBox(
                            height: 300,
                            width: double.infinity,
                            child:
                                Image.network(
                                      widget.project.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[900],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.white24,
                                                  size: 50,
                                                ),
                                              ),
                                            );
                                          },
                                    )
                                    .animate(target: _isHovered ? 1 : 0)
                                    .scale(
                                      begin: const Offset(1, 1),
                                      end: const Offset(1.1, 1.1),
                                      duration: 500.ms,
                                    ),
                          ),
                          // Gradient Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Live Badge
                          if (widget.project.isLive)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                            .animate(
                                              onPlay: (c) =>
                                                  c.repeat(reverse: true),
                                            )
                                            .fade(duration: 1.seconds),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Live App",
                                          style: GoogleFonts.spaceMono(
                                            fontSize: 10,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Content Section
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.project.title,
                                        style: AppTextStyles.heroSubtitle
                                            .copyWith(
                                              fontSize: 24,
                                              color: _isHovered
                                                  ? AppColors.primary
                                                  : Colors.white,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.project.subtitle,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.north_east,
                                  color: _isHovered
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.project.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _isHovered
                                          ? AppColors.primary.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.1),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${widget.project.version} • ${widget.project.updated}",
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  "View Case Study",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    decoration: _isHovered
                                        ? TextDecoration.underline
                                        : null,
                                    decorationColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate(target: widget.isVisible ? 1 : 0)
              .fadeIn(delay: (200 * widget.index).ms, duration: 600.ms)
              .slideX(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOut,
              ),
    );
  }
}

class _FooterHint extends StatelessWidget {
  const _FooterHint();

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.drag_indicator,
              color: AppColors.primary.withOpacity(0.6),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "DRAG OR SCROLL TO EXPLORE PROJECTS",
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                letterSpacing: 1.5,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
          ],
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(begin: 0.5, end: 1.0, duration: 2.seconds);
  }
}
