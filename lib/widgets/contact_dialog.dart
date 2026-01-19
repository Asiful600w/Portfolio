import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class _ContactFormContent extends StatefulWidget {
  const _ContactFormContent();

  @override
  State<_ContactFormContent> createState() => _ContactFormContentState();
}

class _ContactFormContentState extends State<_ContactFormContent> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PLEASE FILL ALL FIELDS',
            style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.from('contact_messages').insert({
        'name': name,
        'email': email,
        'message': message,
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'TRANSMISSION FAILED: $e',
              style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSuccessView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 400),
          decoration: BoxDecoration(
            color: const Color(0xFF05070a).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 50,
                spreadRadius: -5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.primary),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
              )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.elasticOut)
                  .fadeIn(),

              const SizedBox(height: 32),

              Text(
                "TRANSMISSION\nESTABLISHED",
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 16),

              Text(
                "Your message has been successfully logged\non the neural network. We will respond shortly.",
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  color: Colors.white54,
                  height: 1.5,
                ),
              ).animate(delay: 400.ms).fadeIn(),

              const SizedBox(height: 48),

              // Close Button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                    child: Text(
                      "ACKNOWLEDGE",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessView();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 600;

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(
                  0xFF05070a,
                ).withValues(alpha: 0.95),
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
              padding: EdgeInsets.all(isMobile ? 24 : 40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "Let's build something\nextraordinary.",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: isMobile ? 28 : 40,
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
                    )
                        .animate(delay: 100.ms)
                        .fadeIn()
                        .slideY(begin: 0.2, end: 0),

                    SizedBox(height: isMobile ? 32 : 48),

                    // Inputs Row
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmall = constraints.maxWidth < 500;
                        return Flex(
                          direction: isSmall ? Axis.vertical : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: isSmall ? 0 : 1,
                              child: _InputField(
                                label: "OPERATOR NAME",
                                hint: "ENTER ALIAS",
                                controller: _nameController,
                              ),
                            ),
                            SizedBox(
                              width: isSmall ? 0 : 24,
                              height: isSmall ? 24 : 0,
                            ),
                            Expanded(
                              flex: isSmall ? 0 : 1,
                              child: _InputField(
                                label: "COORDINATES",
                                hint: "NAME@DOMAIN.COM",
                                controller: _emailController,
                              ),
                            ),
                          ],
                        );
                      },
                    ).animate(delay: 200.ms).fadeIn(),

                    const SizedBox(height: 32),

                    _InputField(
                      label: "PROJECT PARAMETERS",
                      hint: "Describe mission objectives...",
                      maxLines: 4,
                      controller: _messageController,
                    ).animate(delay: 300.ms).fadeIn(),

                    SizedBox(height: isMobile ? 32 : 48),

                    // Bottom Actions
                    if (isMobile)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SubmitButton(
                            onTap: _submit,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _CircleAction("assets/svgs/face.svg",
                                    "https://www.facebook.com/AsifulIslam112/"),
                                const SizedBox(width: 12),
                                _CircleAction("assets/svgs/ins.svg",
                                    "https://www.instagram.com/asiiifff__chow/"),
                                const SizedBox(width: 12),
                                _CircleAction("assets/svgs/whats.svg",
                                    "https://wa.me/+8801521558737"),
                              ],
                            ),
                          ),
                        ],
                      ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2)
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Socials/Actions
                          Row(
                            children: [
                              _CircleAction("assets/svgs/face.svg",
                                  "https://www.facebook.com/AsifulIslam112/"),
                              const SizedBox(width: 12),
                              _CircleAction("assets/svgs/ins.svg",
                                  "https://www.instagram.com/asiiifff__chow/"),
                              const SizedBox(width: 12),
                              _CircleAction("assets/svgs/whats.svg",
                                  "https://wa.me/+8801521558737"),
                            ],
                          ),

                          // Submit
                          _SubmitButton(
                            onTap: _submit,
                            isLoading: _isLoading,
                          ),
                        ],
                      ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextEditingController? controller;

  const _InputField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.controller,
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
            controller: controller,
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
  final String assetPath;
  final String url;
  const _CircleAction(this.assetPath, this.url);

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
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
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
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            widget.assetPath,
            colorFilter:
                const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const _SubmitButton({this.onTap, this.isLoading = false});

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
      cursor:
          widget.isLoading ? SystemMouseCursors.wait : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onTap,
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
                widget.isLoading
                    ? "TRANSMITTING..."
                    : "INITIALIZE TRANSMISSION",
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
      ),
    );
  }
}
