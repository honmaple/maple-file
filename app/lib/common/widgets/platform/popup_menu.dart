import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pull_down_button/pull_down_button.dart';

abstract class PlatformPopupMenuEntry {
  PopupMenuEntry createMaterialWidget(BuildContext context);
  PullDownMenuEntry createCupertinoWidget(BuildContext context);
}

typedef PlatformPopupMenuBuilder = List<PlatformPopupMenuEntry> Function(
    BuildContext context);

class PlatformPopupMenuItem implements PlatformPopupMenuEntry {
  final String label;
  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback? onTap;
  final Widget? trailing;

  const PlatformPopupMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.trailing,
    this.iconWidget,
  });

  @override
  PopupMenuEntry createMaterialWidget(BuildContext context) {
    return PopupMenuItem(
      onTap: onTap,
      child: ListTile(
        dense: true,
        title: Text(label),
        leading: iconWidget ?? Icon(icon),
        trailing: trailing,
      ),
    );
  }

  @override
  PullDownMenuEntry createCupertinoWidget(BuildContext context) {
    return PullDownMenuItem(
      icon: icon,
      iconWidget: iconWidget,
      title: label,
      onTap: onTap,
    );
  }
}

class PlatformPopupMenuDivider implements PlatformPopupMenuEntry {
  const PlatformPopupMenuDivider();

  @override
  PopupMenuEntry createMaterialWidget(BuildContext context) {
    return PopupMenuDivider(height: 0.1);
  }

  @override
  PullDownMenuEntry createCupertinoWidget(BuildContext context) {
    return PullDownMenuDivider.large();
  }
}

class PlatformPopupMenuButton
    extends PlatformWidgetBase<PullDownButton, PopupMenuButton> {
  final Key? widgetKey;
  final Widget icon;
  final PlatformPopupMenuBuilder itemBuilder;
  final EdgeInsets padding;

  const PlatformPopupMenuButton({
    super.key,
    this.widgetKey,
    this.padding = EdgeInsets.zero,
    required this.icon,
    required this.itemBuilder,
  });

  @override
  PopupMenuButton createMaterialWidget(BuildContext context) {
    return PopupMenuButton(
      key: widgetKey,
      menuPadding: padding,
      position: PopupMenuPosition.under,
      icon: icon,
      itemBuilder: (context) {
        return [
          for (final item in itemBuilder(context))
            item.createMaterialWidget(context),
        ];
      },
    );
  }

  @override
  PullDownButton createCupertinoWidget(BuildContext context) {
    return PullDownButton(
      key: widgetKey,
      itemBuilder: (context) => [
        for (final item in itemBuilder(context))
          item.createCupertinoWidget(context),
      ],
      buttonBuilder: (context, showMenu) => CupertinoButton(
        onPressed: showMenu,
        minSize: 0,
        padding: padding,
        child: icon,
      ),
    );
  }
}

Future<void> showPlatformPopupMenu({
  required BuildContext context,
  required Offset offset,
  required List<PlatformPopupMenuEntry> items,
}) {
  if (isMaterial(context)) {
    return showMenu(
      context: context,
      menuPadding: const EdgeInsets.all(0),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
        // offset.dx + 1,
        // offset.dy + 1,
      ),
      items: [
        for (final item in items) item.createMaterialWidget(context),
      ],
    );
  }
  return showPullDownMenu(
    context: context,
    position: Rect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      // MediaQuery.of(context).size.height + offset.dy,
      offset.dy,
    ),
    items: [
      for (final item in items) item.createCupertinoWidget(context),
    ],
  );
}
