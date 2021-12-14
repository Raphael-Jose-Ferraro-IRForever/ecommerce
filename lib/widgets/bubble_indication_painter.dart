import 'dart:math';
import 'package:flutter/material.dart';

class TabIndicationPainter extends CustomPainter {
  late Paint painter;
  late final double dxTarget;
  late final double dxEntry;
  late final double radius;
  late final double dy;

  late final PageController pageController;

  TabIndicationPainter(
      {required this.dxTarget,
      required this.dxEntry,
      required this.radius,
      required this.dy,
      required this.pageController})
      : super(repaint: pageController) {
    painter = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pos = pageController.position;
    double fullExtent =
        (pos.maxScrollExtent - pos.minScrollExtent + pos.viewportDimension);

    double pageOffset = pos.extentBefore / fullExtent;

    bool left2right = dxEntry < dxTarget;
    Offset entry = Offset(left2right ? dxEntry : dxTarget, dy);
    Offset target = Offset(left2right ? dxTarget : dxEntry, dy);

    Path path = Path();
    path.addArc(
         Rect.fromCircle(center: entry, radius: radius), 0.5 * pi, 1 * pi);
    path.addRect(
         Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(
         Rect.fromCircle(center: target, radius: radius), 1.5 * pi, 1 * pi);

    canvas.translate(size.width * pageOffset, 0.0);
    canvas.drawShadow(path, const Color(0xFFfbab66), 3.0, true);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(TabIndicationPainter oldDelegate) => true;
}
