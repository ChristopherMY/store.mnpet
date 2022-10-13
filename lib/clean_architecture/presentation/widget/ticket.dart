import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  const Ticket({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.shadow,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadow;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        alignment: Alignment.center,
        margin: widget.margin,
        decoration: BoxDecoration(
          boxShadow: widget.shadow,
          color: widget.color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: widget.child,
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: 20.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
