import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';
import '../utils/styles.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // 1. Header (Back Button + Title)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _BackButton(),
                      const Spacer(),
                      _ProjectHeader(
                        title: project.title,
                        subtitle: project.subtitle ?? "Case Study",
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Balance
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // 2. Mockup Carousel
                SizedBox(
                  height: 600,
                  child: _MockupCarousel(
                    images: project.galleryImages.isNotEmpty
                        ? project.galleryImages
                        : const [
                            "https://images.unsplash.com/photo-1551650975-87deedd944c3?w=800&q=80",
                            "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&q=80",
                            "https://images.unsplash.com/photo-1555421689-d68471e189f2?w=800&q=80",
                          ],
                  ),
                ),

                const SizedBox(height: 80),

                // 3. Content Grid (Objective + Specs)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 1024;
                      if (!isDesktop) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ObjectiveSection(objective: project.objective),
                            const SizedBox(height: 48),
                            _SpecsPanel(project: project),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 9,
                            child: _ObjectiveSection(
                                objective: project.objective,
                                features: project.features,
                                architecture: project.architecture),
                          ),
                          const SizedBox(width: 48),
                          Expanded(
                            flex: 3,
                            child: _SpecsPanel(project: project),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 80),

                // 3.5 Description Part (Aligned with Challenges)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle(
                                icon: Icons.text_snippet, title: "DESCRIPTION"),
                            const SizedBox(height: 24),
                            Text(
                              project.description ??
                                  project.subtitle ??
                                  "A complex distributed system designed for high-performance transactions.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 6),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // 4. Challenges Grid (Aligned with Objective Section)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6, // Reduced width (was 9)
                        child: _ChallengesSection(
                          challenges: (project.challenges != null &&
                                  project.challenges!.isNotEmpty)
                              ? project.challenges!
                              : [
                                  {
                                    "title": "Real-time Data Streams",
                                    "description":
                                        "Managing thousands of WebSocket events per second without dropping frames on low-end devices.",
                                    "icon": Icons.flash_on,
                                  },
                                  {
                                    "title": "Key Management",
                                    "description":
                                        "Implementing a non-custodial backup system that is both ultra-secure and impossible to lose.",
                                    "icon": Icons.lock,
                                  },
                                ],
                        ),
                      ),
                      const Spacer(flex: 6), // Increased spacer (was 3)
                      const SizedBox(width: 48), // Padding fix to match above
                    ],
                  ),
                ),

                const SizedBox(height: 100),

                // Copyright Footer (Simple)
                Text(
                  "© 2026 ASIFUL ISLAM - ARCHITECTURAL EXCELLENCE",
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    color: Colors.grey[700],
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Sub-Components
// -----------------------------------------------------------------------------

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.3),
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.primary),
      ),
    ).animate().fadeIn().slideX(begin: -0.2);
  }
}

class _ProjectHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ProjectHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "PROJECT CASE STUDY",
          style: GoogleFonts.spaceMono(
            color: AppColors.primary,
            fontSize: 12,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: AppTextStyles.heroTitle.copyWith(fontSize: 64),
        ).animate().fadeIn().slideY(begin: 0.2),
        const SizedBox(height: 16),
        SizedBox(
          width: 600,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }
}

class _MockupCarousel extends StatefulWidget {
  final List<String> images;

  const _MockupCarousel({required this.images});

  @override
  State<_MockupCarousel> createState() => _MockupCarouselState();
}

class _MockupCarouselState extends State<_MockupCarousel> {
  PageController? _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Center initial page
    _currentPage = widget.images.length ~/ 2;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If no images, show placeholder
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      if (screenWidth == 0) screenWidth = 1000; // Protection

      // Calculate desired viewport fraction to keep items compact
      // Target slot width ~ 320px (Phone width ~267px + margins)
      double fraction = (320.0 / screenWidth).clamp(0.2, 0.85);

      // Re-initialize controller if fraction changes significantly
      if (_controller == null ||
          (_controller!.viewportFraction - fraction).abs() > 0.01) {
        final oldController = _controller;
        _controller = PageController(
          viewportFraction: fraction,
          initialPage: _currentPage,
        );
        oldController?.dispose();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                double value = 0.0;
                if (_controller!.position.haveDimensions) {
                  value = _controller!.page! - index;
                } else {
                  value = (_currentPage - index).toDouble();
                }
                // Value is the distance from the center page.
                // 0 = center, 1 = right, -1 = left.

                // Clamp value to prevent extreme rotations
                final clampedValue = value.clamp(-1.0, 1.0);

                final double distortionValue = Curves.easeOut.transform(
                  1 - (clampedValue.abs() * 0.3),
                );

                final Matrix4 matrix = Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // Perspective
                  ..rotateY(-0.5 * clampedValue) // 3D Rotation
                  ..multiply(Matrix4.diagonal3Values(
                      distortionValue,
                      distortionValue,
                      distortionValue)); // Scale side items down

                final double opacity = 1.0 - (clampedValue.abs() * 0.4);

                return Transform(
                  transform: matrix,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: opacity,
                    child: _PhoneMockup(
                      imageUrl: widget.images[index],
                      isFocused: (value.abs() < 0.2),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}

class _PhoneMockup extends StatelessWidget {
  final String imageUrl;
  final bool isFocused;

  const _PhoneMockup({required this.imageUrl, required this.isFocused});

  @override
  Widget build(BuildContext context) {
    // Aspect Ratio of a modern phone ~9:19.5 -> 0.46
    // Width is constrained by the PageView viewport
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow Effect (Only for focused)
        if (isFocused)
          Positioned(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppColors.primary.withValues(alpha: 0.4), // Subtle glow
                    blurRadius: 60,
                    spreadRadius: -20,
                  ),
                ],
              ),
            ),
          )
              .animate()
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fade(begin: 0.5, end: 0.8, duration: 2.seconds),

        // Phone Frame
        AspectRatio(
          aspectRatio: 9 / 17.5, // Wider aspect ratio
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: isFocused
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.1),
                width: 8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                children: [
                  // Project Image
                  Positioned.fill(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF131517),
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              color: Colors.white24, size: 40),
                        ),
                      ),
                    ),
                  ),

                  // Reflection Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Dimming for non-focused
                  if (!isFocused)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ObjectiveSection extends StatelessWidget {
  final String? objective;
  final List<dynamic>? features;
  final Map<String, dynamic>? architecture;

  const _ObjectiveSection({this.objective, this.features, this.architecture});

  @override
  Widget build(BuildContext context) {
    // Helper to get features or default
    final displayFeatures = (features != null && features!.isNotEmpty)
        ? features!
        : [
            {
              "text": "Zero-latency transaction signing via secure enclave.",
              "icon": Icons.flash_on
            },
            {
              "text":
                  "Cross-chain asset visualization with unified balance view.",
              "icon": Icons.hub
            }
          ];

    // Helper to get architecture nodes or default
    final archNodes = (architecture != null && architecture!['nodes'] != null)
        ? List<String>.from(architecture!['nodes'])
        : ["Flutter UI", "BLoC Layer", "Rust Core", "EVM Nodes"];

    final archDescription = (architecture != null)
        ? architecture!['description'] as String?
        : "Multilayered security architecture utilizing FFI (Foreign Function Interface) for cryptographic primitives.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(icon: Icons.track_changes, title: "OBJECTIVE"),
        const SizedBox(height: 24),
        Text(
          objective ??
              "No objective defined for this project. The primary goal was to create a robust and scalable solution.",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: displayFeatures.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value as Map<String, dynamic>;
            final iconData = feature['icon'] is IconData
                ? feature['icon'] as IconData
                : Icons.code;
            // Basic icon mapping if passing strings from JSON (add more as needed)
            // or rely on a helper if icons are strings. For now assume passing IconData (hardcoded) or need mapping.
            // Since JSON matches are hard, we default to Icons.code or perform simple switch if string.

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _FeatureCard(
                      icon:
                          iconData, // Simplified for now, real implementation needs string->icon map
                      text: feature['text'] ?? "",
                    ),
                  ),
                  if (index != displayFeatures.length - 1)
                    const SizedBox(width: 24),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 48),
        _SectionTitle(icon: Icons.architecture, title: "ARCHITECTURE"),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF131517),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < archNodes.length; i++) ...[
                      _ArchNode(label: archNodes[i], isActive: i == 0),
                      if (i != archNodes.length - 1) _ArchConnector(),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                archDescription ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131517),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchNode extends StatelessWidget {
  final String label;
  final bool isActive;

  const _ArchNode({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.primary : Colors.grey[800]!,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          color: isActive ? AppColors.primary : Colors.grey[400],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ArchConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(Icons.sync_alt, color: Colors.grey[800], size: 20),
    );
  }
}

class _SpecsPanel extends StatelessWidget {
  final ProjectModel project;

  const _SpecsPanel({required this.project});

  @override
  Widget build(BuildContext context) {
    final metrics = project.performanceMetrics ?? {};

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF131517),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SPECIFICATIONS",
                style: GoogleFonts.spaceMono(
                  color: AppColors.primary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              const SizedBox(height: 24),
              _SpecGroup(
                label: "CORE STACK",
                items: project.tags,
              ),
              const SizedBox(height: 24),
              const Text(
                "PERFORMANCE METRICS",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              if (metrics.isEmpty)
                _MetricRow(label: "Target FPS", value: "120 Hz"),
              ...metrics.entries.map((e) => _MetricRow(
                    label: e.key,
                    value: e.value.toString(),
                  )),
              const SizedBox(height: 24),
              const Text(
                "RESOURCES",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              _ResourceButton(
                icon: Icons.code,
                label: "Source Code",
                onTap: () {
                  if (project.projectUrl != null) {
                    debugPrint("Launching ${project.projectUrl}");
                    // TODO: Implement url_launcher
                    // launchUrl(Uri.parse(project.projectUrl!));
                  }
                },
              ),
              const SizedBox(height: 8),
              _ResourceButton(
                icon: Icons.description,
                label: "Whitepaper",
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF131517),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "STATUS: PRODUCTION READY",
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      color: Colors.grey[500],
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Text(
                "V2.4.1",
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecGroup extends StatelessWidget {
  final String label;
  final List<String> items;

  const _SpecGroup({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1113), // Darker inner card
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ResourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ResourceButton> createState() => _ResourceButtonState();
}

class _ResourceButtonState extends State<_ResourceButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(widget.icon,
                  size: 20,
                  color: _isHovered ? AppColors.primary : Colors.white),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isHovered ? Colors.white : Colors.grey[300],
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 14,
                  color: _isHovered ? AppColors.primary : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengesSection extends StatelessWidget {
  final List<dynamic> challenges;

  const _ChallengesSection({required this.challenges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(icon: Icons.warning_amber, title: "CHALLENGES"),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.8, // Increased to reduce height
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
          ),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final item = challenges[index] as Map<String, dynamic>;
            final IconData icon =
                item['icon'] is IconData ? item['icon'] : Icons.bolt;

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['title'] ?? "Challenge",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description'] ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03) // Very subtle grid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw grid lines
    const double gridSize = 40;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
