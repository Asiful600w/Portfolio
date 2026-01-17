import 'package:flutter/material.dart';
import '../utils/styles.dart';

class NavBar extends StatelessWidget {
  final VoidCallback? onAboutClick;
  final VoidCallback? onHomeClick;
  final VoidCallback? onServicesClick;
  final VoidCallback? onProjectsClick;

  const NavBar({
    super.key,
    this.onAboutClick,
    this.onHomeClick,
    this.onServicesClick,
    this.onProjectsClick,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                  15,
                  20,
                  25,
                  0.9,
                ), // Higher opacity since no blur
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.glassBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo Area
                  const _Logo(),

                  // Desktop Menu or Mobile Icon
                  if (isDesktop)
                    _DesktopMenu(
                      onAboutClick: onAboutClick,
                      onHomeClick: onHomeClick,
                      onServicesClick: onServicesClick,
                      onProjectsClick: onProjectsClick,
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white70),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.terminal, color: AppColors.primary),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: 'Asifs',
            style: AppTextStyles.display.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: const [
              TextSpan(
                text: 'Portfolio',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopMenu extends StatelessWidget {
  final VoidCallback? onAboutClick;
  final VoidCallback? onHomeClick;
  final VoidCallback? onServicesClick;
  final VoidCallback? onProjectsClick;
  const _DesktopMenu({
    this.onAboutClick,
    this.onHomeClick,
    this.onServicesClick,
    this.onProjectsClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _menuItem('Home', onTap: onHomeClick),
        const SizedBox(width: 32),
        _menuItem('Projects', onTap: onProjectsClick),
        const SizedBox(width: 32),
        _menuItem('About', onTap: onAboutClick),
        const SizedBox(width: 32),
        _menuItem('Services', onTap: onServicesClick),
      ],
    );
  }

  Widget _menuItem(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: HoverText(
          text: title,
          baseStyle: AppTextStyles.navLink,
          hoverColor: AppColors.primary,
        ),
      ),
    );
  }
}

class HoverText extends StatefulWidget {
  final String text;
  final TextStyle baseStyle;
  final Color hoverColor;

  const HoverText({
    super.key,
    required this.text,
    required this.baseStyle,
    required this.hoverColor,
  });

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: widget.baseStyle.copyWith(
          color: _isHovered ? widget.hoverColor : widget.baseStyle.color,
          shadows: _isHovered
              ? [
                  Shadow(
                    color: widget.hoverColor.withOpacity(0.4),
                    blurRadius: 20,
                  ),
                ]
              : [],
        ),
        child: Text(widget.text),
      ),
    );
  }
}
