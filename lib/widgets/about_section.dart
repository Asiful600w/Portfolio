import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/styles.dart';
import 'about/orbital_skill_matrix.dart';
import '../services/supabase_service.dart';
import '../models/profile_model.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final _supabaseService = SupabaseService();
  late Future<ProfileModel?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _supabaseService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileModel?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final profile = snapshot.data;

        return Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 1024;

              if (!isDesktop) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SectionHeader(),
                    const SizedBox(height: 48),
                    _TopSection(isDesktop: false, profile: profile),
                    const SizedBox(height: 48),
                    const _MobileSkillMatrix(),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionHeader(),
                  const SizedBox(height: 60),
                  SizedBox(
                      height: 600,
                      child: _TopSection(isDesktop: true, profile: profile)),
                  const SizedBox(height: 24),
                  const SizedBox(height: 800, child: OrbitalSkillMatrix()),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _TopSection extends StatelessWidget {
  final bool isDesktop;
  final ProfileModel? profile;

  const _TopSection({
    required this.isDesktop,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 4, child: _ProfileCard(profile: profile)),
          const SizedBox(width: 24),
          Expanded(flex: 8, child: _BioCard(isDesktop: true, profile: profile)),
        ],
      );
    } else {
      return Column(
        children: [
          _ProfileCard(profile: profile),
          const SizedBox(height: 24),
          _BioCard(isDesktop: false, profile: profile),
        ],
      );
    }
  }
}

// -----------------------------------------------------------------------------
// 1. Profile Card
// -----------------------------------------------------------------------------
class _ProfileCard extends StatelessWidget {
  final ProfileModel? profile;
  const _ProfileCard({this.profile});

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: CustomPaint(painter: _NeuralLinesPainter()),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image Wrapper
              SizedBox(
                width: 320,
                height: 320,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: 320,
                    height: 320,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Ring
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .rotate(duration: 15.seconds),

                        // Rotating Dot Container
                        SizedBox(
                          width: 320,
                          height: 320,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 0),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .rotate(duration: 15.seconds),

                        // Middle Ring
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: false))
                            .rotate(begin: 1, end: 0, duration: 25.seconds),

                        // Profile Picture
                        Container(
                          width: 250,
                          height: 250,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary,
                                blurRadius: 50,
                                spreadRadius: -20,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: ClipOval(
                              child: profile?.profileImageUrl != null
                                  ? Image.network(
                                      profile!.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Image.asset(
                                        "assets/images/profile.png",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/images/profile.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        // Scanner Text
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                color: Colors.black,
                                child: const Text(
                                  "SCANNING",
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                color: Colors.black,
                                child: const Text(
                                  "ID: DEV-01",
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                              begin: const Offset(1.1, 1.1),
                              end: const Offset(1.0, 1.0),
                              duration: 2.seconds,
                            ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                profile?.fullName ?? "ASIFUL ISLAM",
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 32,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
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
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(duration: 500.ms),
                  const SizedBox(width: 8),
                  Text(
                    profile?.status ?? "ONLINE_",
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. Bio Card
// -----------------------------------------------------------------------------
class _BioCard extends StatefulWidget {
  final bool isDesktop;
  final ProfileModel? profile;
  const _BioCard({required this.isDesktop, this.profile});

  @override
  State<_BioCard> createState() => _BioCardState();
}

class _BioCardState extends State<_BioCard> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('bio_card_visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: _GlassPanel(
        padding: EdgeInsets.all(widget.isDesktop ? 48 : 24),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: 0,
              child: Text(
                "01",
                style: TextStyle(
                  fontSize: widget.isDesktop ? 160 : 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.03),
                  height: 1,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.terminal,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      _TypingText(
                        text: "SYSTEM_BIO.EXE",
                        isVisible: _isVisible,
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: widget.isDesktop ? 64 : 32,
                      height: 0.9,
                    ),
                    children: [
                      TextSpan(
                        text: widget.profile?.title ?? "Architect",
                        style: TextStyle(
                          color: Colors.transparent,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 800.ms, delay: 500.ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.body.copyWith(
                            fontSize: widget.isDesktop ? 18 : 14,
                            color: Colors.grey[400],
                          ),
                          children: [
                            TextSpan(text: "Initializing "),
                            TextSpan(
                              text: "Flutter Engine ",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.profile?.bio ??
                                  "... I construct immersive digital ecosystems where performance meets aesthetic precision.",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.body.copyWith(
                            fontSize: widget.isDesktop ? 18 : 14,
                            color: Colors.grey[400],
                          ),
                          children: const [
                            TextSpan(
                              text: "Moving beyond static layouts, I engineer ",
                            ),
                            TextSpan(
                              text: "reactive interfaces",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " that adapt and evolve. My code is the bridge between human intent and machine execution, rendered at 120fps.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(duration: 800.ms, delay: 800.ms)
                    .slideX(begin: -0.05),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _Tag(
                      icon: Icons.location_on,
                      text: widget.profile?.location ?? "DHAKA, BD",
                      padding: widget.isDesktop
                          ? const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            )
                          : const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                      fontSize: widget.isDesktop ? 10 : 12,
                    ),
                    _Tag(
                      icon: Icons.code,
                      text: widget.profile?.tagLine ?? "Open Source",
                      padding: widget.isDesktop
                          ? const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            )
                          : const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                      fontSize: widget.isDesktop ? 10 : 12,
                    ),
                  ],
                )
                    .animate(target: _isVisible ? 1 : 0)
                    .fadeIn(delay: 1000.ms)
                    .slideY(begin: 0.2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool isVisible;

  const _TypingText({
    required this.text,
    required this.style,
    required this.isVisible,
  });

  @override
  State<_TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<_TypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _characterCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_TypingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterCount,
      builder: (context, child) {
        String text = widget.text.substring(0, _characterCount.value);
        return Text(
          "$text${_controller.isCompleted ? '' : '_'}",
          style: widget.style,
        );
      },
    );
  }
}

class _Tag extends StatefulWidget {
  final IconData icon;
  final String text;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const _Tag({
    required this.icon,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.fontSize = 12,
  });

  @override
  State<_Tag> createState() => _TagState();
}

class _TagState extends State<_Tag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: widget.fontSize + 4,
              color: _isHovered ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: GoogleFonts.spaceMono(
                fontSize: widget.fontSize,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. Mobile Skill Matrix (Grid + Radar)
// -----------------------------------------------------------------------------
class _MobileSkillMatrix extends StatelessWidget {
  const _MobileSkillMatrix();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Orbital Matrix Container
        LayoutBuilder(
          builder: (context, constraints) {
            return AspectRatio(
              aspectRatio: 1.4,
              child: FittedBox(
                fit: BoxFit.contain,
                child: const SizedBox(
                  width: 600,
                  height: 350,
                  child: OrbitalSkillMatrix(isMobile: true),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassPanel({required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(10, 10, 15, 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    ); // Removed the breathing animation on the panel itself to reduce noise
  }
}

class _NeuralLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width,
      size.height * 0.2,
    );

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.8,
      size.width,
      size.height * 0.5,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
              ),
            ],
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
              ),
              const SizedBox(width: 8),
              Text(
                "WHO_AM_I",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextStyles.heroTitle.copyWith(fontSize: 48, height: 1.1),
            children: [
              const TextSpan(text: "Architect "),
              TextSpan(
                text: "// Bio",
                style: TextStyle(
                  color: AppColors.primary,
                  shadows: [
                    Shadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "> Accessing personnel records. Verified clearance level: ALPHA.\nExploring the intersection of design and logic.",
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'JetBrains Mono',
            fontSize: 14,
            color: Colors.grey[500],
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
