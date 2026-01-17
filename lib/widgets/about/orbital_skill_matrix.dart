import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../utils/styles.dart';

// -----------------------------------------------------------------------------
// 4. Orbital Skill Matrix (Desktop)
// -----------------------------------------------------------------------------
class SkillPlanet {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String description;

  const SkillPlanet({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class OrbitalSkillMatrix extends StatefulWidget {
  const OrbitalSkillMatrix({super.key});

  @override
  State<OrbitalSkillMatrix> createState() => _OrbitalSkillMatrixState();
}

class _OrbitalSkillMatrixState extends State<OrbitalSkillMatrix>
    with TickerProviderStateMixin {
  // Controllers for rings to handle pausing
  late final AnimationController _ring1Controller;
  late final AnimationController _ring2Controller;
  late final AnimationController _ring3Controller;
  late final AnimationController _ring4Controller;
  late final AnimationController _breathingController;
  late final AnimationController _expansionController;
  late final Animation<double> _expansionAnimation;
  bool _isVisible = false;

  SkillPlanet? _activePlanet;

  // Data
  final _planetsRing1 = const [
    SkillPlanet(
      id: "dart",
      label: "DART",
      icon: Icons.code,
      color: Colors.blueAccent,
      description:
          "Type-safe language optimized for UI. Mastering asynchronous programming, isolates, and FFI for high-performance apps.",
    ),
    SkillPlanet(
      id: "testing",
      label: "TESTING",
      icon: Icons.bug_report,
      color: Colors.greenAccent,
      description:
          " robust testing strategies inc. Unit, Widget, and Integration tests to ensure 99.9% crash-free sessions.",
    ),
  ];

  final _planetsRing2 = const [
    SkillPlanet(
      id: "firebase",
      label: "FIREBASE",
      icon: Icons.storage,
      color: Colors.amber,
      description:
          "Scalable backend architecture using Firestore, Cloud Functions, and Auth for real-time data sync and security.",
    ),
    SkillPlanet(
      id: "design",
      label: "DESIGN",
      icon: Icons.palette,
      color: Colors.purpleAccent,
      description:
          "Translating complex UX flows into pixel-perfect Flutter widgets with custom painters and advanced animations.",
    ),
  ];

  final _planetsRing3 = const [
    SkillPlanet(
      id: "perf",
      label: "PERF",
      icon: Icons.speed,
      color: Colors.grey,
      description:
          "Deep profiling with DevTools. Optimizing bind/build times, reducing raster cache misses, and Impeller engine tuning.",
    ),
  ];

  final _planetsRing4 = const [
    SkillPlanet(
      id: "supabase",
      label: "SUPABASE",
      icon: Icons.bolt_rounded,
      color: Colors.tealAccent,
      description:
          "Open Source Firebase alternative. PostgreSQL power with real-time subscriptions, Auth, and Edge Functions.",
    ),
  ];

  final _flutterPlanet = const SkillPlanet(
    id: "flutter",
    label: "FLUTTER",
    icon: Icons.layers,
    color: Colors.blue,
    description:
        "The core framework. Building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.",
  );

  @override
  void initState() {
    super.initState();
    _ring1Controller = AnimationController(vsync: this, duration: 20.seconds);
    _ring2Controller = AnimationController(vsync: this, duration: 30.seconds);
    _ring3Controller = AnimationController(vsync: this, duration: 40.seconds);
    _ring4Controller = AnimationController(vsync: this, duration: 50.seconds);
    _breathingController = AnimationController(vsync: this, duration: 2.seconds)
      ..repeat(reverse: true);

    _expansionController = AnimationController(
      vsync: this,
      duration: 3.seconds,
    );

    _expansionAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeOutExpo,
    );
  }

  @override
  void dispose() {
    _ring1Controller.dispose();
    _ring2Controller.dispose();
    _ring3Controller.dispose();
    _ring4Controller.dispose();
    _breathingController.dispose();
    _expansionController.dispose();
    super.dispose();
  }

  void _onPlanetTap(SkillPlanet planet) {
    setState(() {
      _activePlanet = planet;
    });
    _ring1Controller.stop();
    _ring2Controller.stop();
    _ring3Controller.stop();
    _ring4Controller.stop();
  }

  void _startOrbit() {
    _ring1Controller.repeat();
    _ring2Controller.repeat();
    _ring3Controller.repeat();
    _ring4Controller.repeat();
  }

  void _reset() {
    setState(() {
      _activePlanet = null;
    });
    _ring1Controller.repeat();
    _ring2Controller.repeat();
    _ring3Controller.repeat();
    _ring4Controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // OPTIMIZATION: Isolate painting
      child: VisibilityDetector(
        key: const Key('orbital_matrix_visibility'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.2 && !_isVisible) {
            setState(() => _isVisible = true);
            _expansionController.forward().then((_) => _startOrbit());
          }
        },
        child: GestureDetector(
          onTap: _reset, // Tap anywhere else to reset
          child: _GlassPanel(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Title
                Positioned(
                  top: 24,
                  left: 24,
                  child: AnimatedOpacity(
                    duration: 300.ms,
                    opacity: _activePlanet == null ? 1.0 : 0.3,
                    child: Row(
                      children: [
                        const Icon(Icons.hub, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          "ORBITAL_SKILL_MATRIX",
                          style: AppTextStyles.heroSubtitle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 1. Background Layer (Back half of orbits + planets behind)
                _OrbitRing(
                  size: 1050,
                  yScale: 0.35,
                  controller: _ring4Controller,
                  breathingController: _breathingController,
                  reverse: true,
                  planets: _planetsRing4,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.background,
                  expansionAnimation: _expansionAnimation,
                ),
                _OrbitRing(
                  size: 300,
                  yScale: 0.35,
                  controller: _ring1Controller,
                  breathingController: _breathingController,
                  reverse: false,
                  planets: _planetsRing1,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.background,
                  expansionAnimation: _expansionAnimation,
                ),

                _OrbitRing(
                  size: 550,
                  yScale: 0.35,
                  controller: _ring2Controller,
                  breathingController: _breathingController,
                  reverse: true,
                  planets: _planetsRing2,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.background,
                  expansionAnimation: _expansionAnimation,
                ),

                _OrbitRing(
                  size: 800,
                  yScale: 0.35,
                  controller: _ring3Controller,
                  breathingController: _breathingController,
                  reverse: false,
                  planets: _planetsRing3,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.background,
                  expansionAnimation: _expansionAnimation,
                ),

                // 2. Center - Flutter Core
                AnimatedBuilder(
                  animation: _breathingController,
                  builder: (context, child) {
                    final isFlutterActive = _activePlanet == _flutterPlanet;
                    final breath = _breathingController.value;
                    final blur = isFlutterActive ? 30 + (20 * breath) : 50.0;
                    final spread = isFlutterActive ? 5 + (5 * breath) : 0.0;

                    return GestureDetector(
                      onTap: () => _onPlanetTap(_flutterPlanet),
                      child: AnimatedScale(
                        duration: 500.ms,
                        scale: isFlutterActive
                            ? 1.2
                            : (_activePlanet != null ? 0.8 : 1.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFlutterActive
                                  ? Colors.white
                                  : AppColors.primary,
                              width: isFlutterActive ? 2 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: isFlutterActive ? 0.8 : 0.4,
                                ),
                                blurRadius: isFlutterActive ? blur : 50,
                                spreadRadius: spread,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.layers,
                                color: Colors.blue,
                                size: 40,
                              ),
                              Text(
                                "FLUTTER",
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // 3. Foreground Layer (Front half of orbits + planets in front)
                _OrbitRing(
                  size: 300,
                  yScale: 0.35,
                  controller: _ring1Controller,
                  breathingController: _breathingController,
                  reverse: false,
                  planets: _planetsRing1,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.foreground,
                  expansionAnimation: _expansionAnimation,
                ),

                _OrbitRing(
                  size: 550,
                  yScale: 0.35,
                  controller: _ring2Controller,
                  breathingController: _breathingController,
                  reverse: true,
                  planets: _planetsRing2,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.foreground,
                  expansionAnimation: _expansionAnimation,
                ),

                _OrbitRing(
                  size: 800,
                  yScale: 0.35,
                  controller: _ring3Controller,
                  breathingController: _breathingController,
                  reverse: false,
                  planets: _planetsRing3,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.foreground,
                  expansionAnimation: _expansionAnimation,
                ),

                _OrbitRing(
                  size: 1050,
                  yScale: 0.35,
                  controller: _ring4Controller,
                  breathingController: _breathingController,
                  reverse: true,
                  planets: _planetsRing4,
                  activePlanet: _activePlanet,
                  onPlanetTap: _onPlanetTap,
                  layer: OrbitLayer.foreground,
                  expansionAnimation: _expansionAnimation,
                ),

                // Info Box Overlay
                if (_activePlanet != null)
                  Positioned(
                    right: 40,
                    bottom: 40,
                    child: _PlanetInfoBox(planet: _activePlanet!)
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
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

class _PlanetInfoBox extends StatelessWidget {
  final SkillPlanet planet;
  const _PlanetInfoBox({required this.planet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: planet.color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: planet.color.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(planet.icon, color: planet.color, size: 24),
              const SizedBox(width: 12),
              Text(
                planet.label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 12),
          Text(
            planet.description,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "TAP BG TO CLOSE",
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum OrbitLayer { background, foreground }

class _OrbitRing extends StatelessWidget {
  final double size;
  final double yScale;
  final AnimationController controller;
  final AnimationController breathingController;
  final bool reverse;
  final List<SkillPlanet> planets;
  final SkillPlanet? activePlanet;
  final Function(SkillPlanet) onPlanetTap;
  final OrbitLayer layer;
  final Animation<double>? expansionAnimation;

  const _OrbitRing({
    required this.size,
    required this.controller,
    required this.breathingController,
    required this.reverse,
    required this.planets,
    required this.activePlanet,
    required this.onPlanetTap,
    this.yScale = 0.35,
    this.layer = OrbitLayer.foreground,
    this.expansionAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * yScale,
      child: AnimatedBuilder(
        animation: expansionAnimation ?? const AlwaysStoppedAnimation(1.0),
        builder: (context, child) {
          final scale = expansionAnimation?.value ?? 1.0;
          return Transform.scale(
            scale: scale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ring Line - Drawn ONLY in Background layer
                if (layer == OrbitLayer.background)
                  IgnorePointer(
                    child: AnimatedOpacity(
                      duration: 500.ms,
                      opacity: activePlanet == null ? 1.0 : 0.1,
                      child: CustomPaint(
                        size: Size(size, size * yScale),
                        painter: _EllipseRingPainter(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),

                // Planets
                ...planets.asMap().entries.map((entry) {
                  final index = entry.key;
                  final planet = entry.value;
                  final count = planets.length;
                  final startAngle = (2 * math.pi * index) / count;

                  final isActive = activePlanet == planet;
                  final isOtherActive = activePlanet != null && !isActive;

                  return AnimatedBuilder(
                    animation: Listenable.merge([
                      controller,
                      breathingController,
                    ]),
                    builder: (context, child) {
                      final orbitAngle =
                          (reverse ? -1 : 1) * 2 * math.pi * controller.value;
                      final currentAngle = startAngle + orbitAngle;

                      // Elliptical Position
                      final x = (size / 2) * math.cos(currentAngle);
                      final y = (size / 2) * yScale * math.sin(currentAngle);

                      // Z-Ordering Check
                      bool isBack = math.sin(currentAngle) < 0;

                      bool shouldRender =
                          (layer == OrbitLayer.background && isBack) ||
                          (layer == OrbitLayer.foreground && !isBack);

                      if (!shouldRender) {
                        return const SizedBox.shrink();
                      }

                      // Breathing logic
                      final breath = breathingController.value;
                      final blur = isActive ? 30 + (25 * breath) : 10.0;
                      final spread = isActive ? 5 * breath : 0.0;

                      return Transform.translate(
                        offset: Offset(x, y),
                        child: GestureDetector(
                          onTap: () => onPlanetTap(planet),
                          child: AnimatedContainer(
                            duration: 500.ms,
                            curve: Curves.easeOutBack,
                            width: isActive ? 100 : 60,
                            height: isActive ? 100 : 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isActive ? Colors.white : planet.color,
                                width: isActive ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: planet.color.withOpacity(
                                    isActive ? 0.6 : 0.3,
                                  ),
                                  blurRadius: blur,
                                  spreadRadius: spread,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  planet.icon,
                                  color: planet.color,
                                  size: isActive ? 40 : 24,
                                ),
                                if (isActive) const SizedBox(height: 8),
                                if (planet.label.isNotEmpty)
                                  AnimatedOpacity(
                                    duration: 300.ms,
                                    opacity: isOtherActive ? 0.0 : 1.0,
                                    child: Text(
                                      planet.label,
                                      style: TextStyle(
                                        fontSize: isActive ? 12 : 8,
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                if (isActive) const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EllipseRingPainter extends CustomPainter {
  final Color color;

  _EllipseRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawOval(Offset.zero.translate(0, 0) & size, paint);
  }

  @override
  bool shouldRepaint(covariant _EllipseRingPainter oldDelegate) =>
      oldDelegate.color != color;
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
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
