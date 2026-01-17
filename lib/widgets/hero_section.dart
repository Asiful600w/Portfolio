import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/styles.dart';
import 'contact_dialog.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onProjectsClick;
  const HeroSection({super.key, this.onProjectsClick});

  @override
  Widget build(BuildContext context) {
    // Responsive Layout
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint for lg (1024)
          final isDesktop = constraints.maxWidth > 800;

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _HeroTextContent(onProjectsClick: onProjectsClick),
                ),
                SizedBox(width: 48),
                Expanded(child: _HeroVisuals()),
              ],
            );
          } else {
            return Column(
              children: [
                _HeroTextContent(
                  centered: true,
                  onProjectsClick: onProjectsClick,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Left Side: Text and Actions
// -----------------------------------------------------------------------------
class _HeroTextContent extends StatelessWidget {
  final bool centered;
  final VoidCallback? onProjectsClick;
  const _HeroTextContent({this.centered = false, this.onProjectsClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Available Badge
        _AvailableBadge().animate().fadeIn(duration: 600.ms).slideY(begin: 0.5),

        const SizedBox(height: 24),

        // Title
        RichText(
          textAlign: centered ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            style: AppTextStyles.heroTitle.copyWith(
              fontSize: centered ? 48 : 72,
            ),
            children: const [
              TextSpan(text: "Hello, I'm \n"),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: _GradientText(text: "[Asiful Islam]"),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

        const SizedBox(height: 16),

        // Subtitle
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "Crafting "),
              TextSpan(
                text: "high-performance",
                style: AppTextStyles.heroSubtitle.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.white60,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const TextSpan(text: " digital experiences."),
            ],
          ),
          style: AppTextStyles.heroSubtitle.copyWith(
            fontSize: centered ? 20 : 28,
          ),
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 24),

        // Description
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            "Flutter Specialist building native-quality apps for mobile, web, and desktop using next-gen architecture.",
            style: AppTextStyles.body.copyWith(fontSize: 18),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ).animate().fadeIn(delay: 600.ms),

        const SizedBox(height: 40),

        // Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _PrimaryButton(onTap: onProjectsClick),
            const _SecondaryButton(),
          ],
        ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.5),

        const SizedBox(height: 48),

        // Stats
        Container(
          padding: const EdgeInsets.only(top: 24),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.glassBorder)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _StatItem(value: "5+", label: "Years Exp"),
              SizedBox(width: 40),
              _StatItem(value: "40+", label: "Projects"),
              SizedBox(width: 40),
              _StatItem(value: "100%", label: "Client Sat."),
            ],
          ),
        ).animate().fadeIn(delay: 1000.ms),
      ],
    );
  }
}

class _AvailableBadge extends StatelessWidget {
  const _AvailableBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.primary),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).custom(
                duration: 1.seconds,
                builder: (context, value, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.primary.withValues(alpha: 0.5 * value),
                          blurRadius: 5 + (10 * value),
                          spreadRadius: 2 * value,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
              ),
          const SizedBox(width: 8),
          Text(
            "AVAILABLE FOR HIRE",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  final String text;
  const _GradientText({required this.text});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [AppColors.primary, Colors.blue, AppColors.primary],
        ).createShader(bounds),
        child: Text(
          text,
          style: AppTextStyles.heroTitle.copyWith(
            fontSize: 72,
            // Note: Shadow doesn't show well with ShaderMask on text in flutter web sometimes,
            // but we try. Usually need a duplicate text stack for shadow.
            color: Colors.white, // required for shader mask
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .shimmer(duration: 3.seconds, delay: 2.seconds),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final VoidCallback? onTap;
  const _PrimaryButton({this.onTap});
  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: _isHovered
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Fill Animation
                Positioned.fill(
                  child: AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    widthFactor: _isHovered ? 1.0 : 0.0,
                    alignment: Alignment.centerLeft,
                    child: ColoredBox(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View Projects",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.white,
                      ).animate(target: _isHovered ? 1 : 0).moveX(end: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  const _SecondaryButton();
  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.8),
            builder: (context) => const ContactDialog(),
          );
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.white24,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          transform: _isHovered
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          child: const Text(
            "Contact Me",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.display.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.display.copyWith(
            fontSize: 12,
            color: Colors.white54,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Right Side: Visuals
// -----------------------------------------------------------------------------
class _HeroVisuals extends StatelessWidget {
  const _HeroVisuals();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Flutter wings / Abstract shapes
          // Outer Wing (Blue/Purple)
          // Outer Wing (Blue/Purple)
          RepaintBoundary(
            child: _AbstractShard(
              width: 300,
              height: 80,
              color: Colors.blueAccent.withOpacity(0.2),
              rotate: 45,
              offset: const Offset(-20, -100),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                begin: 0,
                end: -20,
                duration: 4.seconds,
                curve: Curves.easeInOut,
              ),

          // Middle Wing (Primary/Blue)
          // Middle Wing (Primary/Blue)
          RepaintBoundary(
            child: _AbstractShard(
              width: 350,
              height: 90,
              color: AppColors.primary.withValues(alpha: 0.25),
              rotate: 45,
              offset: const Offset(40, 0),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                begin: 0,
                end: 20,
                delay: 1.seconds,
                duration: 5.seconds,
                curve: Curves.easeInOut,
              ),

          // Bottom Wing (Cyan/Primary)
          // Bottom Wing (Cyan/Primary)
          RepaintBoundary(
            child: _AbstractShard(
              width: 250,
              height: 70,
              color: Colors.cyanAccent.withOpacity(0.2),
              rotate: 45,
              offset: const Offset(0, 100),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                begin: 0,
                end: -15,
                delay: 2.seconds,
                duration: 6.seconds,
                curve: Curves.easeInOut,
              ),

          // Glass Cards
          Positioned(
            top: 100,
            right: 50,
            child: RepaintBoundary(
              child: const _GlassCard(
                icon: Icons.flutter_dash,
                title: "Widget Build",
                subtitle: "StatefulWidget",
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                  begin: 0,
                  end: 15,
                  duration: 3.seconds,
                  curve: Curves.easeInOut,
                ),
          ),

          Positioned(
            bottom: 150,
            left: 50,
            child: RepaintBoundary(child: const _CodeCard())
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                  begin: 0,
                  end: -15,
                  delay: 1.5.seconds,
                  duration: 4.seconds,
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    );
  }
}

class _AbstractShard extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double rotate;
  final Offset offset;

  const _AbstractShard({
    required this.width,
    required this.height,
    required this.color,
    required this.rotate,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotate * 3.14159 / 180,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 30),
            ],
          ),
          child: Container(
            color: Colors.transparent,
          ), // for click strictness if needed
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _GlassCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(20, 20, 20, 0.6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * 3.14159 / 180,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(20, 20, 20, 0.6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _dot(Colors.red),
                const SizedBox(width: 6),
                _dot(Colors.amber),
                const SizedBox(width: 6),
                _dot(Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            _line(width: 120, color: Colors.white24),
            const SizedBox(height: 8),
            _line(width: 80, color: Colors.white12),
            const SizedBox(height: 8),
            _line(width: 100, color: AppColors.primary.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
  Widget _line({required double width, required Color color}) => Container(
        width: width,
        height: 6,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}
