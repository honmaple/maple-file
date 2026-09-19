import 'package:flutter/material.dart';

typedef TimelineItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

typedef TimelineNodeStyleBuilder<T> = TimelineNodeStyle Function(
  BuildContext context,
  T item,
  int index,
);

enum TimelineLabelPosition {
  none,
  top,
  left,
}

class TimelineNodeStyle {
  final Color lineColor;
  final Color dotColor;
  final bool showHalo;
  final double dotRadius;
  final double lineWidth;

  const TimelineNodeStyle({
    this.lineColor = const Color(0xFFE4E6EC),
    this.dotColor = const Color(0xFF6366F1),
    this.showHalo = false,
    this.dotRadius = 4.5,
    this.lineWidth = 2,
  });
}

class Timeline<T> extends StatelessWidget {
  final List<T> items;

  final TimelineItemBuilder<T> itemBuilder;
  final TimelineItemBuilder<T>? labelBuilder;
  final TimelineNodeStyleBuilder<T>? nodeStyleBuilder;

  final double labelWidth;
  final double labelSpacing;
  final TimelineLabelPosition labelPosition;

  final double itemSpacing;
  final double timelineWidth;

  const Timeline({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.labelBuilder,
    this.nodeStyleBuilder,
    this.labelPosition = TimelineLabelPosition.top,
    this.labelWidth = 60,
    this.timelineWidth = 32,
    this.itemSpacing = 12,
    this.labelSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          _TimelineRow<T>(
            item: items[index],
            index: index,
            isFirst: index == 0,
            isLast: index == items.length - 1,
            itemBuilder: itemBuilder,
            labelBuilder: labelBuilder,
            nodeStyleBuilder: nodeStyleBuilder,
            labelPosition: labelPosition,
            labelWidth: labelWidth,
            timelineWidth: timelineWidth,
            itemSpacing: itemSpacing,
            labelSpacing: labelSpacing,
          ),
      ],
    );
  }
}

class _TimelineRow<T> extends StatelessWidget {
  final T item;
  final int index;

  final bool isFirst;
  final bool isLast;

  final TimelineItemBuilder<T> itemBuilder;
  final TimelineItemBuilder<T>? labelBuilder;
  final TimelineNodeStyleBuilder<T>? nodeStyleBuilder;

  final TimelineLabelPosition labelPosition;

  final double labelWidth;
  final double timelineWidth;
  final double itemSpacing;
  final double labelSpacing;

  const _TimelineRow({
    required this.item,
    required this.index,
    required this.isFirst,
    required this.isLast,
    required this.itemBuilder,
    required this.labelBuilder,
    required this.nodeStyleBuilder,
    required this.labelPosition,
    required this.labelWidth,
    required this.timelineWidth,
    required this.itemSpacing,
    required this.labelSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final style = nodeStyleBuilder?.call(
          context,
          item,
          index,
        ) ??
        const TimelineNodeStyle();

    final bottomSpacing = isLast ? 0.0 : itemSpacing;

    final label = labelBuilder?.call(context, item, index);

    return Stack(
      children: [
        Positioned(
          left: labelPosition == TimelineLabelPosition.left ? labelWidth : 0,
          top: 0,
          bottom: 0,
          width: timelineWidth,
          child: CustomPaint(
            painter: _TimelinePainter(
              isFirst: isFirst,
              isLast: isLast,
              lineColor: style.lineColor,
              dotColor: style.dotColor,
              showHalo: style.showHalo,
              dotRadius: style.dotRadius,
              lineWidth: style.lineWidth,
              bottomSpacing: bottomSpacing,
              alignment: labelPosition == TimelineLabelPosition.top
                  ? TimelineNodeAlignment.start
                  : TimelineNodeAlignment.center,
            ),
          ),
        ),
        labelPosition == TimelineLabelPosition.left
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: labelWidth,
                    child: label ?? const SizedBox.shrink(),
                  ),
                  SizedBox(width: timelineWidth),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: bottomSpacing,
                      ),
                      child: itemBuilder(context, item, index),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(
                  left: timelineWidth,
                  bottom: bottomSpacing,
                ),
                child: labelPosition == TimelineLabelPosition.none
                    ? itemBuilder(context, item, index)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (label != null) ...[
                            label,
                            SizedBox(height: labelSpacing),
                          ],
                          itemBuilder(context, item, index),
                        ],
                      ),
              )
      ],
    );
  }
}

enum TimelineNodeAlignment {
  start,
  center,
}

class _TimelinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;

  final Color lineColor;
  final Color dotColor;

  final bool showHalo;

  final double dotRadius;
  final double lineWidth;
  final double bottomSpacing;

  final TimelineNodeAlignment alignment;

  _TimelinePainter({
    required this.isFirst,
    required this.isLast,
    required this.lineColor,
    required this.dotColor,
    this.showHalo = false,
    this.dotRadius = 4.5,
    this.lineWidth = 2,
    this.bottomSpacing = 0,
    this.alignment = TimelineNodeAlignment.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final contentHeight = size.height - bottomSpacing;

    final dotY = switch (alignment) {
      TimelineNodeAlignment.start => dotRadius + 4,
      TimelineNodeAlignment.center => contentHeight / 2,
    };

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    final nodeGap = dotRadius + 2;

    if (!isFirst) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, dotY - nodeGap),
        linePaint,
      );
    }

    if (!isLast) {
      canvas.drawLine(
        Offset(x, dotY + nodeGap),
        Offset(x, size.height),
        linePaint,
      );
    }

    if (showHalo) {
      canvas.drawCircle(
        Offset(x, dotY),
        dotRadius + 6,
        Paint()
          ..color = dotColor.withValues(
            alpha: 0.14,
          ),
      );
    }

    canvas.drawCircle(
      Offset(x, dotY),
      dotRadius + 2,
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      Offset(x, dotY),
      dotRadius,
      Paint()..color = dotColor,
    );
  }

  @override
  bool shouldRepaint(
    covariant _TimelinePainter oldDelegate,
  ) {
    return oldDelegate.isFirst != isFirst ||
        oldDelegate.isLast != isLast ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.showHalo != showHalo ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.bottomSpacing != bottomSpacing ||
        oldDelegate.alignment != alignment;
  }
}