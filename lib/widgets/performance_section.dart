import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/styles.dart';

class PerformanceSection extends StatelessWidget {
  const PerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 1024;
              if (isDesktop) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(flex: 7, child: _CodeEditor()),
                      const SizedBox(width: 24),
                      const Expanded(flex: 5, child: _PerformanceMonitor()),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: const [
                    _CodeEditor(),
                    SizedBox(height: 24),
                    _PerformanceMonitor(),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 40),
          const _TechStackFooter(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 1,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 12),
            Text(
              "UNDER THE HOOD",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.white, Colors.grey],
          ).createShader(bounds),
          child: Text(
            "Engineering Velocity",
            style: AppTextStyles.heroTitle.copyWith(fontSize: 56, height: 1),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Code that runs at the speed of thought. Inspect the engine powering the experience.",
          style: AppTextStyles.body.copyWith(
            fontSize: 18,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Power Glass Panel (Reused Logic)
// -----------------------------------------------------------------------------
class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _GlassPanel({required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1419).withValues(alpha: 0.65),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

// -----------------------------------------------------------------------------
// Code Editor
// -----------------------------------------------------------------------------
class _CodeEditor extends StatefulWidget {
  const _CodeEditor();

  @override
  State<_CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<_CodeEditor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Column(
        children: [
          // Editor Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _windowControl(Colors.redAccent),
                    const SizedBox(width: 8),
                    _windowControl(Colors.amber),
                    const SizedBox(width: 8),
                    _windowControl(Colors.greenAccent),
                    const SizedBox(width: 16),
                    Text(
                      "lib/ui/hud/live_render.dart",
                      style: GoogleFonts.getFont(
                        'JetBrains Mono',
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fadeIn(duration: 600.ms),
                    const SizedBox(width: 6),
                    Text(
                      "CONNECTED",
                      style: GoogleFonts.getFont(
                        'JetBrains Mono',
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Editor Content
          Container(
            height: 400,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF090B10).withValues(alpha: 0.8),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.getFont(
                    'JetBrains Mono',
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.grey[300],
                  ),
                  children: [
                    TextSpan(
                      text: "class ",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(
                      text: "HolographicHUD ",
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(
                      text: "extends ",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(
                      text: "CustomPainter ",
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(text: "{\n"),
                    TextSpan(
                      text: "final ",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(
                      text: "Animation<double> ",
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(text: "pulse;\n\n"),
                    TextSpan(
                      text: "HolographicHUD",
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(
                      text:
                          "({required this.pulse}) : super(repaint: pulse);\n\n",
                    ),
                    TextSpan(
                      text: "@override\n",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(
                      text: "void ",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(
                      text: "paint(Canvas canvas, Size size) {\n",
                      style: TextStyle(color: Color(0xFFF1FA8C)),
                    ),
                    TextSpan(
                      text: "final ",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(
                      text:
                          "center = Offset(size.width / 2, size.height / 2);\n",
                    ),
                    TextSpan(
                      text: "final ",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(text: "paint = Paint()\n"),
                    TextSpan(
                      text:
                          "..color = Colors.cyanAccent.withOpacity(pulse.value)\n",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "..style = PaintingStyle.stroke\n",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "..strokeWidth = 1.5;\n\n",
                      style: TextStyle(color: Color(0xFFBD93F9)),
                    ),
                    TextSpan(
                      text: "// Draw the optimized vector path\n",
                      style: TextStyle(color: Color(0xFF6272A4)),
                    ),
                    TextSpan(
                      text: "final ",
                      style: TextStyle(color: Color(0xFFFF79C6)),
                    ),
                    TextSpan(text: "path = Path()\n"),
                    TextSpan(text: "..moveTo(center.dx, center.dy)\n"),
                    TextSpan(
                      text: "..relativeLineTo(50.0 * pulse.value, 0.0)\n",
                    ),
                    TextSpan(text: "..arcToPoint(\n"),
                    TextSpan(
                      text: "Offset(center.dx + 100, center.dy + 50),\n",
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(
                      text: "radius: Radius.circular(12));\n",
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(text: "canvas.drawPath(path, paint);"),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: _BlinkingCursor(),
                    ),
                    TextSpan(text: "\n  }\n}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _windowControl(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 500.ms)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SizedBox(
            width: 10,
            height: 18,
            child: ColoredBox(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Performance Monitor
// -----------------------------------------------------------------------------
class _PerformanceMonitor extends StatefulWidget {
  const _PerformanceMonitor();

  @override
  State<_PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<_PerformanceMonitor> {
  int _selectedIndex = 0; // 0: iOS, 1: Android, 2: Web

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Monitor
        _GlassPanel(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.monitor_heart_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "PERFORMANCE MONITOR",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _SegmentBtn(
                          label: "iOS",
                          isSelected: _selectedIndex == 0,
                          onTap: () => setState(() => _selectedIndex = 0),
                        ),
                        _SegmentBtn(
                          label: "Android",
                          isSelected: _selectedIndex == 1,
                          onTap: () => setState(() => _selectedIndex = 1),
                        ),
                        _SegmentBtn(
                          label: "Web",
                          isSelected: _selectedIndex == 2,
                          onTap: () => setState(() => _selectedIndex = 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // FPS Counter
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _selectedIndex == 2 ? "60" : "120",
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: 64,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "FPS",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          size: 14,
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "STABLE",
                          style: GoogleFonts.getFont(
                            'JetBrains Mono',
                            fontSize: 10,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Graph
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _AnimatedGraph(selection: _selectedIndex),
                ),
              ),

              const SizedBox(height: 16),
              // Legend
              Row(
                children: [
                  _legendItem(AppColors.primary, "UI Thread"),
                  const SizedBox(width: 16),
                  _legendItem(Colors.blueAccent, "Raster Cache"),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Metrics Grid
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: "Frame Build Time",
                value: "<16ms",
                tag: "OPTIMIZED",
                tagColor: Colors.greenAccent,
                icon: Icons.timelapse,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _MetricCard(
                label: "Rendering Engine",
                value: "Impeller",
                tag: "VULKAN",
                tagColor: Colors.purpleAccent,
                icon: Icons.layers,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) => Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.getFont(
              'JetBrains Mono',
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      );
}

class _SegmentBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentBtn({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String tag;
  final Color tagColor;
  final IconData icon;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.tag,
    required this.tagColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.grey[600], size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: tagColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.heroSubtitle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.getFont(
              'JetBrains Mono',
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedGraph extends StatefulWidget {
  final int selection;
  const _AnimatedGraph({required this.selection});

  @override
  State<_AnimatedGraph> createState() => _AnimatedGraphState();
}

class _AnimatedGraphState extends State<_AnimatedGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 2.seconds)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RepaintBoundary(
          child: CustomPaint(
            painter: _FpsGraphPainter(
              offset: _controller.value,
              selection: widget.selection,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _FpsGraphPainter extends CustomPainter {
  final double offset;
  final int selection;

  _FpsGraphPainter({required this.offset, required this.selection});

  @override
  void paint(Canvas canvas, Size size) {
    // Grid Lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height * 0.25),
      Offset(size.width, size.height * 0.25),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.75),
      Offset(size.width, size.height * 0.75),
      gridPaint,
    );

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create sine wave
    path.moveTo(0, height);

    for (double x = 0; x <= width; x++) {
      // Create a moving wave effect
      final normalizeX = x / width;
      final waveX = normalizeX * 4 * math.pi + (offset * math.pi * 2);

      double y = height * 0.6;

      if (selection == 0) {
        // iOS: Smooth, stable sine wave
        y += (math.sin(waveX) * height * 0.2) +
            (math.sin(waveX * 2) * height * 0.1);
      } else if (selection == 1) {
        // Android: More complex, higher frequency
        y += (math.sin(waveX * 1.5) * height * 0.15) +
            (math.cos(waveX * 2.5) * height * 0.15);
      } else {
        // Web: Flatter, "60fps" feel
        y += (math.sin(waveX * 0.8) * height * 0.1) +
            (math.sin(waveX * 3) * height * 0.05);
      }

      path.lineTo(x, y);
    }

    path.lineTo(width, height);
    path.close();

    // Fill Gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withValues(alpha: 0.3),
        AppColors.primary.withValues(alpha: 0.0),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Stroke Line
    final strokePath = Path();
    for (double x = 0; x <= width; x++) {
      final normalizeX = x / width;
      final waveX = normalizeX * 4 * math.pi + (offset * math.pi * 2);

      double y = height * 0.6;
      if (selection == 0) {
        y += (math.sin(waveX) * height * 0.2) +
            (math.sin(waveX * 2) * height * 0.1);
      } else if (selection == 1) {
        y += (math.sin(waveX * 1.5) * height * 0.15) +
            (math.cos(waveX * 2.5) * height * 0.15);
      } else {
        y += (math.sin(waveX * 0.8) * height * 0.1) +
            (math.sin(waveX * 3) * height * 0.05);
      }
      if (x == 0) {
        strokePath.moveTo(x, y);
      } else {
        strokePath.lineTo(x, y);
      }
    }

    final strokePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _FpsGraphPainter oldDelegate) =>
      oldDelegate.offset != offset || oldDelegate.selection != selection;
}

class _TechStackFooter extends StatelessWidget {
  const _TechStackFooter();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Wrap(
        spacing: 32,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: const [
          _TechItem(
            icon: Icons.flutter_dash,
            color: Colors.blueAccent,
            label: "Flutter 3.19",
          ),
          _TechItem(
            icon: Icons.code,
            color: Colors.orangeAccent,
            label: "Dart 3.3",
          ),
          _TechItem(
            icon: Icons.memory,
            color: Colors.greenAccent,
            label: "FFI Optimized",
          ),
          _TechItem(
            icon: Icons.bolt,
            color: Colors.purpleAccent,
            label: "Impeller Enabled",
          ),
        ],
      ),
    );
  }
}

class _TechItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _TechItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
