import 'package:flutter/material.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:maple_file/common/utils/color.dart';

import 'animation.dart';

class CustomTab {
  final IconData icon;
  final String label;

  const CustomTab({
    required this.icon,
    required this.label,
  });
}

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    this.initialIndex = 0,
    required this.items,
    this.onItemChanged,
  });

  final int initialIndex;
  final List<CustomTab> items;
  final GestureTapIndexCallback? onItemChanged;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: widget.items.length,
      child: ConvexAppBar.builder(
        count: widget.items.length,
        itemBuilder: _CustomBuilder(
          items: widget.items,
          color: Colors.grey,
          activeColor: colorScheme.primary,
        ),
        height: 56,
        top: -16,
        curveSize: 56,
        elevation: 0,
        backgroundColor: ColorUtil.secondaryBackgroundColor(context),
        onTap: widget.onItemChanged,
      ),
    );
  }
}

class _CustomBuilder extends DelegateBuilder {
  final List<CustomTab> items;
  final Color? color;
  final Color? activeColor;

  _CustomBuilder({
    required this.items,
    this.color,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context, int index, bool active) {
    final item = items[index];
    final textScheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    if (active) {
      return Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomAnimationBuilder(
            data: index,
            tween: Tween(begin: 24.0, end: 42.0),
            duration: Duration(milliseconds: 200),
            builder: (context, animation, _) {
              return Container(
                width: animation.value,
                height: animation.value,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
                child: Icon(
                  item.icon,
                  size: 24,
                  color: colorScheme.onPrimary,
                ),
              );
            },
          ),
          Text(
            item.label,
            style: textScheme.labelMedium?.copyWith(color: activeColor),
          )
        ],
      );
    }
    return Container(
      color: Colors.transparent,
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(item.icon, size: 24, color: color),
          Text(
            item.label,
            style: textScheme.labelMedium?.copyWith(color: color),
          )
        ],
      ),
    );
  }

  @override
  bool fixed() {
    return false;
  }
}