import 'package:flutter/material.dart';

class HoverText extends StatefulWidget {
  final Widget child;
  final String text;

  final double h;
  final double w;

  HoverText({required this.child, required this.text, required this.h, required this.w});

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Row(
        children: [
          widget.child,
          if (isHovered)
               Container(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: widget.h,
                    width: widget.w,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10.0),
                        top: Radius.circular(10.0),
                      )
                    ),
                    child: Center(child: Text(widget.text, style: const TextStyle(fontSize: 12.0, color: Colors.white)))))
    ],
    ));
  }
}