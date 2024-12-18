import 'package:flutter/material.dart';

class Breakpoint {
  final double start;
  final double end;

  const Breakpoint({required this.start, required this.end});

  Breakpoint copyWith({
    double? start,
    double? end,
  }) =>
      Breakpoint(
        start: start ?? this.start,
        end: end ?? this.end,
      );

  @override
  String toString() => 'Breakpoint(start: $start, end: $end)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Breakpoint &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode * end.hashCode;

  bool isActive(BuildContext context) =>
      MediaQuery.of(context).size.width < end &&
      MediaQuery.of(context).size.width >= start;

  static const Breakpoint small = Breakpoint(start: 0, end: 600);
  static const Breakpoint mobile = Breakpoint(start: 0, end: 450);
  static const Breakpoint tablet = Breakpoint(start: 450, end: 800);
  static const Breakpoint desktop =
      Breakpoint(start: 800, end: double.infinity);

  static bool isSmall(BuildContext context) =>
      Breakpoint.small.isActive(context);

  static bool isMobile(BuildContext context) =>
      Breakpoint.mobile.isActive(context);

  static bool isTablet(BuildContext context) =>
      Breakpoint.tablet.isActive(context);

  static bool isDesktop(BuildContext context) =>
      Breakpoint.desktop.isActive(context);
}

typedef ResponsiveBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints);

class Responsive extends StatelessWidget {
  const Responsive({super.key, required this.builder, this.others = const {}});

  final ResponsiveBuilder builder;
  final Map<Breakpoint, ResponsiveBuilder> others;

  @override
  Widget build(BuildContext context) {
    ResponsiveBuilder? otherBuilder;
    for (final key in others.keys) {
      if (key.isActive(context)) {
        otherBuilder = others[key];
        break;
      }
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return otherBuilder?.call(context, constraints) ??
            builder(context, constraints);
      },
    );
  }
}
