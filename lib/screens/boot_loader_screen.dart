import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/styles.dart';
import '../home_screen.dart';

class BootLoaderScreen extends StatefulWidget {
  const BootLoaderScreen({super.key});

  @override
  State<BootLoaderScreen> createState() => _BootLoaderScreenState();
}

class _BootLoaderScreenState extends State<BootLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _spinController;

  String _currentStatus = "Initializing Digital Architecture...";
  String _detailStatus = "> Loading: /assets/check_system_integrity";
  int _percentage = 0;

  final List<String> _bootSequence = [
    "Initializing Digital Architecture...",
    "Verifying System Integrity...",
    "Loading Core Modules...",
    "Establishing Secure Connection...",
    "Optimizing Neural Networks...",
    "Compiling Assets...",
    "System Ready.",
  ];

  final List<String> _fileSequence = [
    "> Loading: /assets/shaders/fragment_shader.glsl",
    "> Loading: /core/kernel_io.dart",
    "> Verifying: /security/encryption_keys.pem",
    "> Mounting: /ui/dashboard_widgets.lib",
    "> Syncing: /network/secure_channel.socket",
    "> Rendering: /visuals/particle_system.gpu",
  ];

  @override
  void initState() {
    super.initState();

    // Main Progress Controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    _progressController.addListener(() {
      setState(() {
        _percentage = (_progressController.value * 100).toInt();

        // Update status text based on progress
        int statusIndex =
            (_progressController.value * (_bootSequence.length - 1)).toInt();
        _currentStatus = _bootSequence[statusIndex];

        // Update detail text faster
        int detailIndex =
            ((_progressController.value * 20).toInt()) % _fileSequence.length;
        _detailStatus = _fileSequence[detailIndex];
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });

    // Pulse Animation for glows
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Spin Animation for the ring
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Start sequence
    Timer(const Duration(milliseconds: 500), () {
      _progressController.forward();
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: AppColors.bootBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Effects
          const RepaintBoundary(child: _BackgroundEffects()),

          // 2. Code Streams (Hidden on small mobile if needed, but keeping for effect)
          if (!isMobile)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: RepaintBoundary(
                child: _CodeStreamColumn(
                  sourceCode: _leftSourceCode,
                  alignment: CrossAxisAlignment.start,
                ),
              ),
            ),

          if (!isMobile)
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: RepaintBoundary(
                child: _CodeStreamColumn(
                  sourceCode: _rightSourceCode,
                  alignment: CrossAxisAlignment.end,
                ),
              ),
            ),

          // 3. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Status Bar
                _buildHeader(isMobile),

                const Spacer(),

                // Centre Emblem
                RepaintBoundary(child: _buildCenterEmblem(size)),

                const SizedBox(height: 60),

                // Status Text
                Text(
                  _currentStatus,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                      Shadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "ESTABLISH SECURE CONNECTION",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    letterSpacing: 3.0,
                    color: AppColors.primary.withOpacity(0.6),
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 40),

                // Progress Bar Section
                RepaintBoundary(
                  child: _buildProgressSection(
                    size.width * (isMobile ? 0.9 : 0.5),
                  ),
                ),

                const Spacer(),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        color: AppColors.backgroundDark.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.terminal, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                "SYS_BOOT_SEQUENCE_V4.2.0",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  letterSpacing: 2.0,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          if (!isMobile)
            Row(
              children: [
                _buildStatusIndicator("MEM: 64GB OK", Colors.green),
                const SizedBox(width: 24),
                _buildStatusIndicator("NET: SECURE", AppColors.primary),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Icon(Icons.lock_outline, size: 14, color: Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      "ENCRYPTED",
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        color: Colors.white54,
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

  Widget _buildStatusIndicator(String label, Color color) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color.withOpacity(0.5 + (_pulseController.value * 0.5)),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(_pulseController.value),
                    blurRadius: 6,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.spaceMono(fontSize: 10, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildCenterEmblem(Size size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Glow
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.primary.withOpacity(0.1), Colors.transparent],
              radius: 0.7,
            ),
          ),
        ),

        // Rotating Ring
        AnimatedBuilder(
          animation: _spinController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _spinController.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(200, 200),
                painter: DashedRingPainter(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
            );
          },
        ),

        // Inner Circle
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
        ),

        // Flutter Logo / Center Symbol
        FlutterLogo(
          size: 100,
          style: FlutterLogoStyle.markOnly,
          textColor: AppColors.primary,
        ),

        // Beam Glow overlay on logo
        IgnorePointer(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ASSET COMPILATION",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      color: Colors.white38,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.sync, color: AppColors.primary, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        "Processing modules...",
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "$_percentage",
                    style: GoogleFonts.spaceMono(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: AppColors.primary, blurRadius: 10),
                      ],
                    ),
                  ),
                  Text(
                    "%",
                    style: GoogleFonts.spaceMono(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress Bar
          Container(
            height: 16,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Fill
                    Container(
                      width: constraints.maxWidth * _progressController.value,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.6),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    // Striped Pattern Overlay (Simulated)
                    Positioned.fill(
                      child: ClipRect(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: StripePatternPainter(
                              progress: _progressController.value,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Leading white beam
                    Positioned(
                      left:
                          (constraints.maxWidth * _progressController.value) -
                          2,
                      width: 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Detail Meta Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _detailStatus,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: Colors.white30,
                ),
              ),
              Text(
                "[ EST: ${(4.5 * (1 - _progressController.value)).toStringAsFixed(1)}s ]",
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: Colors.white30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterIcon(Icons.memory, "CORE"),
              const SizedBox(width: 32),
              _buildFooterIcon(Icons.code, "SYNTAX"),
              const SizedBox(width: 32),
              _buildFooterIcon(Icons.widgets, "UI/UX"),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "SYSTEM INTEGRITY VERIFIED // READY FOR DEPLOYMENT",
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              color: Colors.white24,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            color: Colors.white60,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Helper Widgets & Painters
// -----------------------------------------------------------------------------

class _BackgroundEffects extends StatelessWidget {
  const _BackgroundEffects();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Radial Gradient Center
        Center(
          child: Container(
            width: 800,
            height: 800,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.indigo.shade900.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
        ),

        // Scanlines
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: CustomPaint(painter: ScanlinePainter()),
          ),
        ),
      ],
    );
  }
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.height; i += 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedRingPainter extends CustomPainter {
  final Color color;
  DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const dashWidth = 20.0;
    const dashSpace = 15.0;
    double startAngle = 0;

    // Draw dashed circle
    while (startAngle < 2 * math.pi) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashWidth / radius,
        false,
        paint,
      );
      startAngle += (dashWidth + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StripePatternPainter extends CustomPainter {
  final double progress;
  final Color color;

  StripePatternPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // Draw diagonal stripes
    for (double i = -size.height; i < size.width; i += 10) {
      Path path = Path()
        ..moveTo(i, size.height)
        ..lineTo(i + 5, size.height)
        ..lineTo(i + size.height + 5, 0)
        ..lineTo(i + size.height, 0)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CodeStreamColumn extends StatelessWidget {
  final String sourceCode;
  final CrossAxisAlignment alignment;

  const _CodeStreamColumn({required this.sourceCode, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Opacity(
        opacity: 0.1,
        child: Text(
          sourceCode,
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.right
              : TextAlign.left,
          style: GoogleFonts.firaCode(
            fontSize: 10,
            color: AppColors.primary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

const String _leftSourceCode = '''
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SystemBoot());
}

class SystemBoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SystemState>(
      stream: _kernel.statusStream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return Loader();
        return Dashboard();
      },
    );
  }
}

Future<void> initSystem() async {
  await loadCore();
  await verifyIntegrity();
  // Initialize Flux Capacitor
  Flux.start();
}
''';

const String _rightSourceCode = '''
import 'package:flutter/material.dart';
import 'package:system/kernel_io.dart';

final _controller = StreamController.broadcast();

Future<void> initDrivers() async {
  await Graphics.loadShaders();
  await Audio.synthesize();
  Network.connect(secure: true);
}

// Flux Capacitor status: ONLINE
// Rendering Engine: SKIA_NEXT
const double _pi = 3.14159;
Color _neon = Color(0xFF00EEFF);

abstract class Driver {
  Future<void> init();
  void dispose();
}
''';
