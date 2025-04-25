import 'package:flutter/material.dart';

class HoverButtonWidget extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color hoverColor;
  final Color textColor;

  const HoverButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.hoverColor,
    required this.textColor,
  });

  @override
  State<HoverButtonWidget> createState() => _HoverButtonWidgetState();
}

class _HoverButtonWidgetState extends State<HoverButtonWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isHovered ? widget.hoverColor : widget.backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                color: widget.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setHover(bool hovered) {
    setState(() {
      isHovered = hovered;
    });
  }
}
