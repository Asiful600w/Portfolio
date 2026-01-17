import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/styles.dart';

class ContactDialog extends StatelessWidget {
  const ContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: _ContactFormContent(),
      ),
    );
  }
}

class _ContactFormContent extends StatelessWidget {
  const _ContactFormContent();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(
              0xFF05070a,
            ).withValues(alpha: 0.95), // Deep dark background
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: -10,
              ),
            ],
          ),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Let's build something\nextraordinary.",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 40,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              Text(
                "Ready to deploy your vision? Initialize\ncommunication below.",
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  color: AppColors.primary,
                  height: 1.5,
                ),
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 48),

              // Inputs Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 500;
                  return Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: isMobile ? 0 : 1,
                        child: const _InputField(
                          label: "OPERATOR NAME",
                          hint: "ENTER ALIAS",
                        ),
                      ),
                      SizedBox(
                        width: isMobile ? 0 : 24,
                        height: isMobile ? 24 : 0,
                      ),
                      Expanded(
                        flex: isMobile ? 0 : 1,
                        child: const _InputField(
                          label: "COORDINATES",
                          hint: "NAME@DOMAIN.COM",
                        ),
                      ),
                    ],
                  );
                },
              ).animate(delay: 200.ms).fadeIn(),

              const SizedBox(height: 32),

              const _InputField(
                label: "PROJECT PARAMETERS",
                hint: "Describe mission objectives...",
                maxLines: 4,
              ).animate(delay: 300.ms).fadeIn(),

              const SizedBox(height: 48),

              // Bottom Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Socials/Actions
                  Row(
                    children: [
                      _CircleAction(Icons.code),
                      const SizedBox(width: 12),
                      _CircleAction(Icons.alternate_email),
                      const SizedBox(width: 12),
                      _CircleAction(Icons.link),
                    ],
                  ),

                  // Submit
                  _SubmitButton(),
                ],
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;

  const _InputField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            color: AppColors.primary.withValues(alpha: 0.5),
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: TextField(
            maxLines: maxLines,
            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.spaceGrotesk(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleAction extends StatefulWidget {
  final IconData icon;
  const _CircleAction(this.icon);

  @override
  State<_CircleAction> createState() => _CircleActionState();
}

class _CircleActionState extends State<_CircleAction> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: 200.ms,
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isHovered
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(widget.icon, color: Colors.white70, size: 18),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.send_rounded,
              color: AppColors.primary,
              size: 18,
            ).animate(target: _isHovered ? 1 : 0).moveX(end: 4),
            const SizedBox(width: 12),
            Text(
              "INITIALIZE TRANSMISSION",
              style: GoogleFonts.spaceMono(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
