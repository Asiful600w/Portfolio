import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/styles.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('services_section_visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _SectionHeader()
                .animate(target: _isVisible ? 1 : 0)
                .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 800.ms,
                  curve: Curves.easeOutQuart,
                ),
            const SizedBox(height: 60),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isDesktop = width > 1100;
                final isMobile = width <= 600;

                if (isDesktop) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child:
                              _ServiceCard(
                                    title: "MVP Nexus",
                                    subtitle: "CLASS: PROTOTYPE",
                                    price: "100",
                                    priceSuffix: "\$",
                                    priceNote: "// PER PROJECT EXECUTION",
                                    features: const [
                                      "Rapid Prototyping",
                                      "iOS & Android Build",
                                      "Basic State Management",
                                      "1 Month Support Vector",
                                    ],
                                    actionLabel: "INITIALIZE MVP",
                                    icon:
                                        Icons.api, // Placeholder for Cube icon
                                    accentColor: AppColors.primary,
                                    isMobile: isMobile,
                                    useSpacer: true,
                                  )
                                  .animate(target: _isVisible ? 1 : 0)
                                  .fadeIn(delay: 200.ms, duration: 600.ms)
                                  .slideX(
                                    begin: -0.2,
                                    end: 0,
                                    duration: 800.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child:
                              _ServiceCard(
                                    title: "Innovation Core",
                                    subtitle: "CLASS: SCALABLE",
                                    price: "250",
                                    priceSuffix: "\$",
                                    priceNote: "// PER PROJECT EXECUTION",
                                    features: const [
                                      "Custom Animations Engine",
                                      "Advanced API Integration",
                                      "Scalable Architecture",
                                      "CI/CD Pipeline Setup",
                                      "3 Month Optimization",
                                    ],
                                    actionLabel: "DEPLOY CORE",
                                    isRecommended: true,
                                    icon: Icons
                                        .radio_button_checked, // Placeholder for Core icon
                                    accentColor: AppColors.primary,
                                    isMobile: isMobile,
                                    useSpacer: true,
                                  )
                                  .animate(target: _isVisible ? 1 : 0)
                                  .fadeIn(delay: 400.ms, duration: 600.ms)
                                  .slideY(
                                    begin: 0.2,
                                    end: 0,
                                    duration: 800.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child:
                              _ServiceCard(
                                    title: "Enterprise Orbit",
                                    subtitle: "CLASS: SYSTEMIC",
                                    price: "Query",
                                    priceSuffix: "REQ",
                                    priceNote: "// ONGOING PARTNERSHIP",
                                    features: const [
                                      "Dedicated Squad",
                                      "Microservices",
                                      "AI/ML Integration",
                                      "24/7 System Monitoring",
                                    ],
                                    actionLabel: "CONTACT COMMAND",
                                    icon:
                                        Icons.hub, // Placeholder for Orbit icon
                                    accentColor: const Color(
                                      0xFFA855F7,
                                    ), // Purple accent
                                    isMobile: isMobile,
                                    useSpacer: true,
                                  )
                                  .animate(target: _isVisible ? 1 : 0)
                                  .fadeIn(delay: 600.ms, duration: 600.ms)
                                  .slideX(
                                    begin: 0.2,
                                    end: 0,
                                    duration: 800.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Tablet && Mobile Layout
                  return Column(
                    children: [
                      _buildStackedCard(
                        _ServiceCard(
                              title: "MVP Nexus",
                              subtitle: "CLASS: PROTOTYPE",
                              price: "3k",
                              priceSuffix: "CR",
                              priceNote: "// PER PROJECT EXECUTION",
                              features: const [
                                "Rapid Prototyping",
                                "iOS & Android Build",
                                "Basic State Management",
                                "1 Month Support Vector",
                              ],
                              actionLabel: "INITIALIZE MVP",
                              icon: Icons.api,
                              accentColor: AppColors.primary,
                              isMobile: isMobile,
                              useSpacer: false,
                            )
                            .animate(target: _isVisible ? 1 : 0)
                            .fadeIn(delay: 200.ms, duration: 600.ms)
                            .slideX(
                              begin: -0.2,
                              end: 0,
                              duration: 800.ms,
                              curve: Curves.easeOutBack,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _buildStackedCard(
                        _ServiceCard(
                              title: "Innovation Core",
                              subtitle: "CLASS: SCALABLE",
                              price: "8.5k",
                              priceSuffix: "CR",
                              priceNote: "// PER PROJECT EXECUTION",
                              features: const [
                                "Custom Animations Engine",
                                "Advanced API Integration",
                                "Scalable Architecture",
                                "CI/CD Pipeline Setup",
                                "3 Month Optimization",
                              ],
                              actionLabel: "DEPLOY CORE",
                              isRecommended: true,
                              icon: Icons.radio_button_checked,
                              accentColor: AppColors.primary,
                              isMobile: isMobile,
                              useSpacer: false,
                            )
                            .animate(target: _isVisible ? 1 : 0)
                            .fadeIn(delay: 400.ms, duration: 600.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 800.ms,
                              curve: Curves.easeOutBack,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _buildStackedCard(
                        _ServiceCard(
                              title: "Enterprise Orbit",
                              subtitle: "CLASS: SYSTEMIC",
                              price: "Query",
                              priceSuffix: "REQ",
                              priceNote: "// ONGOING PARTNERSHIP",
                              features: const [
                                "Dedicated Squad",
                                "Microservices",
                                "AI/ML Integration",
                                "24/7 System Monitoring",
                              ],
                              actionLabel: "CONTACT COMMAND",
                              icon: Icons.hub,
                              accentColor: const Color(0xFFA855F7),
                              isMobile: isMobile,
                              useSpacer: false,
                            )
                            .animate(target: _isVisible ? 1 : 0)
                            .fadeIn(delay: 600.ms, duration: 600.ms)
                            .slideX(
                              begin: 0.2,
                              end: 0,
                              duration: 800.ms,
                              curve: Curves.easeOutBack,
                            ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedCard(Widget card) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      width: double.infinity,
      child: card,
    );
  }
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
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
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
                "SYSTEM ONLINE",
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
              const TextSpan(text: "Service "),
              TextSpan(
                text: "Architecture",
                style: TextStyle(
                  color: AppColors.primary,
                  shadows: [
                    Shadow(
                      color: AppColors.primary.withOpacity(0.5),
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
          "> Initialize project protocol. Select a data core to begin\ndevelopment sequence.",
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

class _ServiceCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String priceSuffix;
  final String priceNote;
  final List<String> features;
  final String actionLabel;
  final IconData icon;
  final Color accentColor;
  final bool isRecommended;
  final bool isMobile;
  final bool useSpacer;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.priceSuffix,
    required this.priceNote,
    required this.features,
    required this.actionLabel,
    required this.icon,
    required this.accentColor,
    this.isRecommended = false,
    this.isMobile = false,
    this.useSpacer = true,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isRecommended || _isHovered
        ? widget.accentColor.withOpacity(0.5)
        : Colors.white.withOpacity(0.05);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: EdgeInsets.all(widget.isMobile ? 24 : 32),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1419).withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            if (widget.isRecommended || _isHovered)
              BoxShadow(
                color: widget.accentColor.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isRecommended) ...[
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    "RECOMMENDED MODULE",
                    style: GoogleFonts.getFont(
                      'JetBrains Mono',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.heroSubtitle.copyWith(
                        fontSize: widget.isMobile ? 20 : 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.getFont(
                        'JetBrains Mono',
                        fontSize: 12,
                        color: Colors.grey[500],
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Icon(
                      widget.icon,
                      size: 40,
                      color: _isHovered
                          ? widget.accentColor
                          : widget.accentColor.withOpacity(0.5),
                    )
                    .animate(target: _isHovered ? 1 : 0)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                    )
                    .custom(
                      builder: (context, value, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) => RadialGradient(
                            center: Alignment.center,
                            radius: 0.5,
                            colors: [
                              widget.accentColor,
                              widget.accentColor.withOpacity(0.0),
                            ],
                            stops: const [0.5, 1.0],
                          ).createShader(bounds),
                          child: child,
                        );
                      },
                    ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  widget.price,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: widget.isMobile ? 36 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.priceSuffix,
                  style: GoogleFonts.getFont(
                    'JetBrains Mono',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.priceNote,
              style: GoogleFonts.getFont(
                'JetBrains Mono',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ...widget.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: widget.accentColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      feature,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.useSpacer)
              const Spacer()
            else
              const SizedBox(height: 32),
            InkWell(
              onTap: () {},
              onHover: (value) {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isHovered
                      ? LinearGradient(
                          colors: [
                            widget.accentColor.withOpacity(0.2),
                            widget.accentColor.withOpacity(0.1),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.accentColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  widget.actionLabel,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'JetBrains Mono',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: widget.accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
