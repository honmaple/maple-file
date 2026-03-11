import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

const double _kBaseDividerMargin = 20.0;
const double _kBaseAdditionalDividerMargin = 44.0;
const double _kInsetAdditionalDividerMargin = 42.0;
const double _kInsetAdditionalDividerMarginWithoutLeading = 14.0;

class CustomListSection extends StatelessWidget {
  static NullableIndexedWidgetBuilder _childrenBuilder(List<Widget> children) {
    return (BuildContext context, int index) {
      return children[index];
    };
  }

  CustomListSection({
    super.key,
    this.header,
    this.footer,
    this.margin = const EdgeInsets.fromLTRB(20, 10, 20, 10),
    this.dividerMargin = _kBaseDividerMargin,
    double? additionalDividerMargin,
    bool hasLeading = true,
    this.separatorColor,
    this.backgroundColor,
    List<Widget> children = const <Widget>[],
  })  : itemCount = children.length,
        itemBuilder = _childrenBuilder(children),
        additionalDividerMargin = additionalDividerMargin ??
            (hasLeading ? _kBaseAdditionalDividerMargin : 0.0);

  const CustomListSection.builder({
    super.key,
    this.header,
    this.footer,
    required this.itemCount,
    required this.itemBuilder,
    this.margin = const EdgeInsets.fromLTRB(20, 10, 20, 10),
    this.dividerMargin = _kBaseDividerMargin,
    double? additionalDividerMargin,
    bool hasLeading = true,
    this.separatorColor,
    this.backgroundColor,
  }) : additionalDividerMargin = additionalDividerMargin ??
            (hasLeading
                ? _kInsetAdditionalDividerMargin
                : _kInsetAdditionalDividerMarginWithoutLeading);

  final Widget? header;
  final Widget? footer;

  final EdgeInsetsGeometry margin;
  final double dividerMargin;
  final double additionalDividerMargin;

  final Color? separatorColor;
  final Color? backgroundColor;

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final Color dividerColor =
        separatorColor ?? CupertinoColors.separator.resolveFrom(context);
    final double dividerHeight = 1.0 / MediaQuery.devicePixelRatioOf(context);

    final Widget shortDivider = Container(
      margin: EdgeInsetsDirectional.only(
        start: dividerMargin + additionalDividerMargin,
      ),
      color: dividerColor,
      height: dividerHeight,
    );
    return Container(
      margin: margin,
      child: Column(
        children: [
          if (header != null)
            Container(
              margin: EdgeInsets.only(bottom: 6),
              alignment: AlignmentDirectional.centerStart,
              child: header,
            ),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              BorderRadius? borderRadius;
              if (itemCount == 1) {
                borderRadius = BorderRadius.all(Radius.circular(8));
              } else if (index == 0) {
                borderRadius = BorderRadius.vertical(top: Radius.circular(8));
              } else if (index == itemCount - 1) {
                borderRadius =
                    BorderRadius.vertical(bottom: Radius.circular(8));
              }
              return Container(
                decoration: BoxDecoration(
                  color: CupertinoDynamicColor.resolve(
                    backgroundColor ??
                        CupertinoColors.secondarySystemGroupedBackground,
                    context,
                  ),
                  borderRadius: borderRadius,
                ),
                child: itemBuilder(context, index),
              );
            },
            separatorBuilder: (context, index) {
              return shortDivider;
            },
          ),
        ],
      ),
    );
  }
}

class CustomPlatformListSection
    extends PlatformWidgetBase<CupertinoListSection, CustomListSection> {
  final Key? widgetKey;
  final Widget? header;
  final Widget? footer;
  final List<Widget> children;

  const CustomPlatformListSection({
    super.key,
    this.widgetKey,
    this.header,
    this.footer,
    required this.children,
  });

  @override
  CustomListSection createMaterialWidget(BuildContext context) {
    return CustomListSection(
      key: widgetKey,
      header: header,
      footer: footer,
      children: children,
    );
  }

  @override
  CupertinoListSection createCupertinoWidget(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      key: widgetKey,
      header: header,
      footer: footer,
      children: children,
    );
  }
}

class PlatformListTileChevron
    extends PlatformWidgetBase<CupertinoListTileChevron, Widget> {
  final Key? widgetKey;

  const PlatformListTileChevron({
    super.key,
    this.widgetKey,
  });

  @override
  Widget createMaterialWidget(BuildContext context) {
    return Icon(Icons.chevron_right);
  }

  @override
  CupertinoListTileChevron createCupertinoWidget(BuildContext context) {
    return CupertinoListTileChevron(key: widgetKey);
  }
}
