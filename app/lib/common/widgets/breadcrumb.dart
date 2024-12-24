import 'package:flutter/material.dart';

class BreadcrumbItem extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;

  const BreadcrumbItem({
    super.key,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    }
    return child;
  }
}

class Breadcrumb extends StatelessWidget {
  final Widget divider;
  final List<Widget> children;

  const Breadcrumb({
    super.key,
    this.divider = const Icon(Icons.chevron_right, size: 18),
    required this.children,
  });

  Breadcrumb.builder({
    super.key,
    this.divider = const Icon(Icons.chevron_right, size: 18),
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) : children = List<Widget>.generate(
          itemCount,
          (i) => Builder(builder: (context) => itemBuilder(context, i)),
        );

  @override
  Widget build(BuildContext context) {
    List<Widget> items = <Widget>[];

    for (final (index, child) in children.indexed) {
      items.add(child);
      if (index < children.length - 1) {
        items.add(divider);
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items,
      ),
    );
  }
}
