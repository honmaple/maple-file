import 'dart:math' as math;
import 'package:flutter/material.dart';

class TooltipShapeBorder extends ShapeBorder {
  final double width;
  final double height;
  final double arrowArc;
  final double radius;

  const TooltipShapeBorder({
    this.radius = 2,
    this.width = 16.0,
    this.height = 8.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: height);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      null ?? Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, height));
    double x = width, y = height, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.topCenter.dx + width / 2, rect.topCenter.dy)
      ..relativeLineTo(-x / 2 * r, -y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), -y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class StatsMap extends StatelessWidget {
  const StatsMap({
    super.key,
    required this.datasets,
    this.size = kDefaultFontSize,
    this.spacing = 3,
    this.labelSpacing = 8,
    this.color = Colors.deepPurple,
    this.lessColor = const Color.fromARGB(255, 235, 237, 240),
    this.startWeek = 7,
    this.startDate,
    this.endDate,
    this.weekLabelStyle,
    this.monthLabelStyle,
    this.showLabel = true,
    this.showWeekLabel = true,
    this.showMonthLabel = true,
    this.weekLabel = const [
      "日",
      "",
      "二",
      "",
      "四",
      "",
      "六",
    ],
    this.monthLabel = const [
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月',
    ],
    this.onTap,
    this.onTooltip,
  });

  final Color color;
  final Color lessColor;

  final double size;
  final double spacing;
  final double labelSpacing;

  final int startWeek;
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<DateTime, int>? datasets;

  final bool showLabel;
  final bool showWeekLabel;
  final bool showMonthLabel;
  final TextStyle? weekLabelStyle;
  final TextStyle? monthLabelStyle;

  final List<String> weekLabel;
  final List<String> monthLabel;

  final Function(DateTime, int)? onTap;
  final String Function(DateTime, int)? onTooltip;

  final _monthHeight = 18.0;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    DateTime _startDate = startDate ?? DateTime(now.year, 1, 1);
    if (_startDate.weekday != startWeek) {
      _startDate = _startDate.add(Duration(
        days: startWeek - 7 - _startDate.weekday,
      ));
    }
    DateTime _endDate = endDate ?? now.add(Duration(days: 7));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showWeekLabel) buildWeekLabel(context),
            if (showWeekLabel) SizedBox(width: labelSpacing),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showMonthLabel)
                      buildMonthLabel(context, _startDate, _endDate),
                    if (showMonthLabel) SizedBox(height: labelSpacing),
                    buildBoxes(context, _startDate, _endDate),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showLabel) SizedBox(height: labelSpacing),
        if (showLabel) buildLabel(context),
      ],
    );
  }

  buildLabel(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "Less",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(width: 2),
          for (int i = 0; i < 7; i++)
            Container(
              width: size,
              height: size,
              color: Color.lerp(lessColor, color, i / 7),
            ),
          const SizedBox(width: 2),
          Text(
            "More",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  buildWeekLabel(BuildContext context) {
    List<Widget> children = [
      if (showMonthLabel)
        SizedBox(
            height: monthLabelStyle?.height ??
                _monthHeight + labelSpacing - spacing),
    ];

    final weekStyle =
        Theme.of(context).textTheme.labelMedium?.merge(monthLabelStyle);
    for (int index = 0; index < weekLabel.length; index++) {
      final week = weekLabel[(startWeek + index) % 7];
      children.add(
        SizedBox(
          height: size + spacing,
          // margin: EdgeInsets.fromLTRB(0, 0, 0, spacing),
          child: week == "" ? null : Text(week, style: weekStyle),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  buildMonthLabel(
    BuildContext context,
    DateTime _startDate,
    DateTime _endDate,
  ) {
    List<Widget> children = [];

    final monthHeight = monthLabelStyle?.height ?? _monthHeight;
    final monthStyle =
        Theme.of(context).textTheme.labelMedium?.merge(monthLabelStyle);

    final _totalDays = (_endDate.difference(_startDate).inHours / 24).round();
    for (int index = 0; index <= _totalDays; index += 7) {
      final currentDate = _startDate.add(Duration(days: index));

      final nextWeek = currentDate.add(Duration(days: 7));
      if (currentDate.month != nextWeek.month) {
        final _month = monthLabel[nextWeek.month - 1];
        if (_month == "") {
          continue;
        }
        final nextMonth = DateTime(nextWeek.year, nextWeek.month + 1, 1);
        if (nextMonth.isAfter(_endDate)) {
          children.add(Container(
            height: monthHeight,
            child: Text(
              "${_month}",
              style: monthStyle,
            ),
          ));
        } else {
          children.add(Container(
              height: monthHeight,
              width: (nextMonth.difference(currentDate).inHours / 24 / 7)
                      .truncateToDouble() *
                  (size + spacing),
              child: Text(
                "${_month}",
                style: monthStyle,
              )));
        }
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  buildBoxes(
    BuildContext context,
    DateTime _startDate,
    DateTime _endDate,
  ) {
    List<Widget> children = [];
    List<Widget> columns = [];

    int maxCount = 1;
    datasets?.forEach((item, c) => maxCount = math.max(maxCount, c));

    final _totalDays = (_endDate.difference(_startDate).inHours / 24).round();
    for (int index = 0; index <= _totalDays; index++) {
      final currentDate = _startDate.add(Duration(days: index));

      if (columns.length == 7) {
        children.add(Column(
          children: columns,
        ));
        columns = [];
      }

      final count = datasets?[currentDate] ?? 0;
      final child = Container(
        decoration: BoxDecoration(
          color: Color.lerp(lessColor, color, count.toDouble() / maxCount),
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        width: size,
        height: size,
        margin: EdgeInsets.fromLTRB(0, 0, spacing, spacing),
      );
      columns.add(
        GestureDetector(
          onTap: onTap == null ? null : () => onTap!(currentDate, count),
          child: onTooltip == null
              ? child
              : Tooltip(
                  message: onTooltip!(currentDate, count),
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: TooltipShapeBorder(width: size, height: size / 2),
                  ),
                  verticalOffset: 10,
                  child: child,
                ),
          // : Tooltip(message: onTooltip!(currentDate, count), child: box),
        ),
      );
    }
    if (columns.isNotEmpty) {
      children.add(Column(
        children: columns,
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
