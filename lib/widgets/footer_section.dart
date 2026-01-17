import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/styles.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black, // Total black
      child: Stack(
        children: [
          // 1. Background (Topo Path + Curves)
          const Positioned.fill(child: _NeuralBackground()),

          // 2. Content
          Column(
            children: [
              const SizedBox(height: 80),
              // Header & Input Console
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _TopSection(),
              ),

              const SizedBox(height: 80),

              const Divider(color: Colors.white10, height: 1),

              // Grid Info (System, Nav, Socials)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                child: _InfoGrid(),
              ),

              // Bottom Status Bar
              _BottomStatusBar(),
            ],
          ),
        ],
      ),
    );
  }
}

class _NeuralBackground extends StatelessWidget {
  const _NeuralBackground();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          // Dot Pattern
          Opacity(
            opacity: 0.3,
            child: CustomPaint(
              painter: _DotPatternPainter(),
              size: Size.infinite,
            ),
          ),
          // Curves
          Positioned.fill(child: CustomPaint(painter: _CurvePainter())),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Draw simple grid of dots
    const step = 40.0;
    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final paint2 = Paint()
      ..color = const Color(0xFF8F27E6).withValues(alpha: 0.1) // Accent Violet
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.3,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.3,
    );

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.4,
      size.width * 0.6,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width,
      size.height * 0.6,
    );

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopSection extends StatelessWidget {
  const _TopSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary,
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                ),
            const SizedBox(width: 12),
            Text(
              "NEURAL_COMM_HUB",
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Input Console
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Glass Input
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                            decoration: InputDecoration(
                              hintText: "INPUT TRANSMISSION ID (EMAIL)",
                              hintStyle: GoogleFonts.spaceGrotesk(
                                color: Colors.white24,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                            ),
                          ),
                        ),
                        _SendButton(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Status Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SECURITY LEVEL: ENCRYPTED",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 8,
                        color: Colors.white24,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "STATUS: READY TO BROADCAST",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 8,
                        color: Colors.white24,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatefulWidget {
  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              "SEND_TRANSMISSION",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.send, color: Colors.black, size: 14),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _SystemEnvironment(isMobile: false)),
              Expanded(
                flex: 6,
                child: Center(child: _FooterNav(isMobile: false)),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _SocialRelay(isMobile: false),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _SystemEnvironment(isMobile: true),
              const SizedBox(height: 48),
              _FooterNav(isMobile: true),
              const SizedBox(height: 48),
              _SocialRelay(isMobile: true),
            ],
          );
        }
      },
    );
  }
}

class _SystemEnvironment extends StatelessWidget {
  final bool isMobile;
  const _SystemEnvironment({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _EnvItem(
          label: "SYSTEM ENVIRONMENT",
          value: "FLUTTER_ARCH_3.19",
          valueColor: AppColors.primary,
          prefix: "01",
        ),
        const SizedBox(height: 24),
        _EnvItem(
          label: "CORE INTEGRITY",
          value: "SECURE_CONNECTION",
          valueColor: const Color(0xFF8F27E6),
          prefix: "99%",
        ),
      ],
    );
  }
}

class _EnvItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final String prefix;

  const _EnvItem({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 9,
            color: Colors.white38,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              prefix,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterNav extends StatelessWidget {
  final bool isMobile;
  const _FooterNav({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: isMobile ? 24 : 48,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: const [
        _NavNode(number: "01", label: "TERMINAL"),
        _NavNode(number: "02", label: "EXPERIENCE"),
        _NavNode(number: "03", label: "PROJECTS"),
        _NavNode(number: "04", label: "ENCRYPTED_FILES"),
      ],
    );
  }
}

class _NavNode extends StatefulWidget {
  final String number;
  final String label;

  const _NavNode({required this.number, required this.label});

  @override
  State<_NavNode> createState() => _NavNodeState();
}

class _NavNodeState extends State<_NavNode> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        children: [
          Text(
            widget.number,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 8,
              color: _isHovered ? AppColors.primary : Colors.white30,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              color: _isHovered ? Colors.white : Colors.white60,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialRelay extends StatelessWidget {
  final bool isMobile;
  const _SocialRelay({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        Text(
          "SOCIAL_RELAY",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 9,
            color: Colors.white38,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _SocialNode(Icons.public),
            SizedBox(width: 16),
            _SocialNode(Icons.camera_alt),
            SizedBox(width: 16),
            _SocialNode(Icons.chat_bubble_outline),
            SizedBox(width: 16),
            _SocialNode(Icons.share),
            SizedBox(width: 16),
            _SocialNode(Icons.code),
          ],
        ),
      ],
    );
  }
}

class _SocialNode extends StatefulWidget {
  final IconData icon;
  const _SocialNode(this.icon);

  @override
  State<_SocialNode> createState() => _SocialNodeState();
}

class _SocialNodeState extends State<_SocialNode> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF8F27E6).withValues(alpha: 0.5)
                : Colors.white10,
          ),
          boxShadow: _isHovered
              ? [
                  const BoxShadow(
                    color: Color(0xFF8F27E6),
                    blurRadius: 15,
                    spreadRadius: -5,
                  ),
                ]
              : [],
        ),
        child: Icon(
          widget.icon,
          size: 16,
          color: _isHovered ? const Color(0xFF8F27E6) : Colors.white38,
        ),
      ),
    );
  }
}

class _BottomStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white.withValues(alpha: 0.02),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16,
            spacing: 24,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("SYSTEM LATENCY: 12MS", style: _statusStyle),
                  const SizedBox(width: 16),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text("LOCATION: 127.0.0.1", style: _statusStyle),
                ],
              ),
              Text(
                "© 2026 NEURAL COMMAND. ALL PROTOCOL RIGHTS RESERVED.",
                style: _statusStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _statusStyle => GoogleFonts.spaceGrotesk(
        fontSize: 8,
        color: Colors.white24,
        letterSpacing: 5,
        fontWeight: FontWeight.bold,
      );
}
