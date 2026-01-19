import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/about_section.dart';
import 'widgets/performance_section.dart';
import 'widgets/background_layers.dart';
import 'widgets/services_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/footer_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/nav_bar.dart';
import 'widgets/mobile_drawer.dart';
import 'widgets/contact_dialog.dart';
import 'utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final aboutKey = GlobalKey();
  final projectsKey = GlobalKey();
  final servicesKey = GlobalKey();
  final scrollController = ScrollController();
  bool _showScrollIndicator = true;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    // Auto-hide scroll indicator after 3 seconds
    Future.delayed(3.seconds, () {
      if (mounted) setState(() => _showScrollIndicator = false);
    });

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!mounted) return;
    // Show back-to-top button when scrolled past 500px
    final show = scrollController.offset > 500;
    if (show != _showScrollToTop) {
      setState(() => _showScrollToTop = show);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: MobileDrawer(
        onHomeClick: () {
          scrollController.animateTo(
            0,
            duration: 1.seconds,
            curve: Curves.easeInOut,
          );
        },
        onProjectsClick: () {
          if (projectsKey.currentContext != null) {
            Scrollable.ensureVisible(
              projectsKey.currentContext!,
              duration: 1.seconds,
              curve: Curves.easeInOut,
            );
          }
        },
        onAboutClick: () {
          if (aboutKey.currentContext != null) {
            Scrollable.ensureVisible(
              aboutKey.currentContext!,
              duration: 1.seconds,
              curve: Curves.easeInOut,
            );
          }
        },
        onServicesClick: () {
          if (servicesKey.currentContext != null) {
            Scrollable.ensureVisible(
              servicesKey.currentContext!,
              duration: 1.seconds,
              curve: Curves.easeInOut,
            );
          }
        },
        onContactClick: () {
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.8),
            builder: (context) => const ContactDialog(),
          );
        },
      ),
      body: Stack(
        children: [
          // 1. Background (Fixed)
          const Positioned.fill(child: BackgroundLayers()),

          // 2. Scrollable Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 100), // Spacing for fixed navbar
                  HeroSection(
                    onProjectsClick: () {
                      if (projectsKey.currentContext != null) {
                        Scrollable.ensureVisible(
                          projectsKey.currentContext!,
                          duration: 1.seconds,
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 100), // Spacing
                  // 4. About Section
                  AboutSection(key: aboutKey),

                  // 6. Performance Section
                  const PerformanceSection(),

                  const SizedBox(height: 100), // Spacing
                  // 7. Services Section
                  ServicesSection(key: servicesKey),

                  const SizedBox(height: 100), // Spacing
                  // 8. Projects Section
                  ProjectsSection(key: projectsKey),

                  // 9. Footer Section
                  const FooterSection(),
                ],
              ),
            ),
          ),

          // 3. Fixed Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: NavBar(
                onHomeClick: () {
                  scrollController.animateTo(
                    0,
                    duration: 1.seconds,
                    curve: Curves.easeInOut,
                  );
                },
                onProjectsClick: () {
                  if (projectsKey.currentContext != null) {
                    Scrollable.ensureVisible(
                      projectsKey.currentContext!,
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                    );
                  }
                },
                onAboutClick: () {
                  if (aboutKey.currentContext != null) {
                    Scrollable.ensureVisible(
                      aboutKey.currentContext!,
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                    );
                  }
                },
                onServicesClick: () {
                  if (servicesKey.currentContext != null) {
                    Scrollable.ensureVisible(
                      servicesKey.currentContext!,
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ),

          // 4. Scroll Indicator (Auto-hide after 3s)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_showScrollIndicator,
              child: AnimatedOpacity(
                duration: 500.ms,
                opacity: _showScrollIndicator ? 1.0 : 0.0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "SCROLL",
                        style: AppTextStyles.display.copyWith(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 20,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Container(
                            width: 4,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ).animate(onPlay: (c) => c.repeat()).moveY(
                                begin: -5,
                                end: 5,
                                duration: 1.5.seconds,
                                curve: Curves.easeInOut,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 5. Scroll-to-Top Button
          Positioned(
            bottom: 30,
            right: 30,
            child: AnimatedScale(
              scale: _showScrollToTop ? 1.0 : 0.0,
              duration: 300.ms,
              curve: Curves.easeOutBack,
              child: GestureDetector(
                onTap: () {
                  scrollController.animateTo(
                    0,
                    duration: 1.seconds,
                    curve: Curves.easeInOutCubic,
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
