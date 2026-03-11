import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformSegment<T> {
  const PlatformSegment({
    required this.value,
    this.icon,
    this.label,
    this.tooltip,
    this.enabled = true,
  }) : assert(icon != null || label != null);

  final T value;
  final Widget? icon;
  final Widget? label;
  final String? tooltip;
  final bool enabled;
}

class PlatformSegmentedButton<T extends Object> extends PlatformWidgetBase<
    CupertinoSegmentedControl<T>, SegmentedButton<T>> {
  final PlatformBuilder<MaterialScaffoldData>? material;
  final PlatformBuilder<CupertinoPageScaffoldData>? cupertino;

  final Key? widgetKey;
  final T? groupValue;
  final ValueChanged<T> onValueChanged;
  final List<PlatformSegment> segments;
  final EdgeInsetsGeometry? padding;

  const PlatformSegmentedButton({
    super.key,
    this.widgetKey,
    required this.segments,
    required this.onValueChanged,
    this.groupValue,
    this.padding,
    this.material,
    this.cupertino,
  });

  @override
  SegmentedButton<T> createMaterialWidget(BuildContext context) {
    return SegmentedButton<T>(
      style: SegmentedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(horizontal: -1, vertical: -1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      showSelectedIcon: false,
      segments: <ButtonSegment<T>>[
        for (final seg in segments)
          ButtonSegment<T>(
            icon: seg.icon,
            label: seg.label,
            value: seg.value,
          ),
      ],
      selected: groupValue == null ? <T>{} : <T>{groupValue!},
      onSelectionChanged: (Set<T> set) {
        onValueChanged(set.first);
      },
    );
  }

  @override
  CupertinoSegmentedControl<T> createCupertinoWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CupertinoSegmentedControl<T>(
      unselectedColor: colorScheme.surface,
      padding: EdgeInsets.zero,
      groupValue: groupValue,
      onValueChanged: onValueChanged,
      children: {
        for (final seg in segments)
          seg.value: Container(
            padding: padding,
            child: Row(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (seg.icon != null) seg.icon!,
                if (seg.label != null) seg.label!,
              ],
            ),
          ),
      },
    );
  }
}
