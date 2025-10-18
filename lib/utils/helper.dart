import 'package:flutter/material.dart';

class CircularOuterNotchedShape extends NotchedShape {
  final double extra;
  const CircularOuterNotchedShape({this.extra = 6});

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    final Path hostPath = Path()..addRect(host);

    if (guest == null || guest.isEmpty) return hostPath;

    final double r = guest.width / 2 + extra;

    final Rect bump = Rect.fromCircle(center: guest.center, radius: r);
    final Path bumpPath = Path()..addOval(bump);

    return Path.combine(PathOperation.union, hostPath, bumpPath);
  }
}

double w(BuildContext context, double size) =>
    size * MediaQuery.of(context).size.width / 375;

double h(BuildContext context, double size) =>
    size * MediaQuery.of(context).size.height / 812;
