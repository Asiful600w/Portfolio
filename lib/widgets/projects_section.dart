import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/styles.dart';
import '../services/supabase_service.dart';
import '../models/project_model.dart';
import '../screens/project_details_screen.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false;
  final _supabaseService = SupabaseService();
  late Future<List<ProjectModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _supabaseService.getProjects();
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            double sidePadding = (MediaQuery.of(context).size.width - 1400) / 2;
            if (sidePadding < 24) sidePadding = 24;

            return Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
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
                  height: 480,
                  child: FutureBuilder<List<ProjectModel>>(
                    future: _projectsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final projects = snapshot.data ?? [];
                      if (projects.isEmpty) {
                        return const Center(child: Text("No projects found."));
                      }

                      return ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: sidePadding),
                        itemCount: projects.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (context, index) {
                          return _ProjectCard(
                            project: projects[index],
                            index: index,
                            isVisible: _isVisible,
                          );
                        },
                      );
                    },
                  ),
                ),

                // Footer Hint
                const SizedBox(height: 32),
                const _FooterHint(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _SectionHeader({required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      // margin removed as padding is handled by parent
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
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "DEPLOYMENTS",
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: AppColors.primary.withValues(alpha: 0.8),
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
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
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
    final cardWidth =
        isMobile ? MediaQuery.of(context).size.width * 0.8 : 420.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ProjectDetailsScreen(project: widget.project),
            ),
          );
        },
        child: AnimatedContainer(
          duration: 300.ms,
          width: cardWidth,
          transform:
              Matrix4.translationValues(0.0, _isHovered ? -10.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2124).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.1),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
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
                  clipBehavior: Clip.hardEdge,
                  children: [
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            widget.project.imageUrl ??
                                "https://placehold.co/600x400",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
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
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).animate(target: _isHovered ? 1 : 0).scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.1, 1.1),
                            duration: 500.ms,
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
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
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
                                        onPlay: (c) => c.repeat(reverse: true),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.project.title,
                                  style: AppTextStyles.heroSubtitle.copyWith(
                                    fontSize: 24,
                                    color: _isHovered
                                        ? AppColors.primary
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.project.subtitle ?? "",
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
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isHovered
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : Colors.white.withValues(alpha: 0.1),
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
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.project.version ?? ''} • ${widget.project.statusLabel ?? ''}",
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
                              decoration:
                                  _isHovered ? TextDecoration.underline : null,
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
          color: AppColors.primary.withValues(alpha: 0.6),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          "DRAG OR SCROLL TO EXPLORE PROJECTS",
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            letterSpacing: 1.5,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ],
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(begin: 0.5, end: 1.0, duration: 2.seconds);
  }
}
