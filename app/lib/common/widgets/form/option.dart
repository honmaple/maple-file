import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/dialog.dart';

import 'common.dart';

class CustomListTileOptions<T> extends CustomListTileBase<T> {
  const CustomListTileOptions({
    super.key,
    required super.label,
    required super.onTap,
    required this.options,
    super.value,
    super.leading,
    super.subtitle,
    super.trailing,
    super.isRequired,
    this.usePage = false,
  });

  final bool usePage;
  final List<CustomOption<T>> options;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      title: Row(
        children: [
          Text(label),
          if (isRequired) Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
      leading: leading,
      trailing: trailing ?? buildTrailing(context, showChevron: true),
      subtitle: subtitle,
      onTap: () async {
        T? result;
        if (usePage) {
          result = await Navigator.of(context).push(platformPageRoute(
              context: context,
              builder: (context) {
                return _CustomOptions(
                  label: label,
                  value: value,
                  options: options,
                );
              }));
        } else {
          result = await showCustomListOptions(
            context: context,
            options: options,
          );
        }
        if (result != null) {
          onTap(result);
        }
      },
    );
  }

  @override
  buildTrailing(
    BuildContext context, {
    bool showChevron = false,
  }) {
    final isEmpty = value == null || value == "";

    final option = options.where((o) => o.value == value);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          isEmpty ? "未设置".tr() : option.firstOrNull?.label ?? "$value",
          maxLines: 1,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (showChevron)
          isMaterial(context)
              ? const Icon(Icons.chevron_right)
              : CupertinoListTileChevron(),
      ],
    );
  }
}

class _CustomOptions<T> extends StatelessWidget {
  const _CustomOptions({
    super.key,
    this.value,
    required this.label,
    required this.options,
  });

  final T? value;
  final String label;
  final List<CustomOption<T>> options;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text(label),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CupertinoListSection.insetGrouped(
            hasLeading: false,
            dividerMargin: 4,
            children: [
              for (final option in options)
                PlatformListTile(
                  leading: option.icon,
                  title: Text(option.label == null
                      ? "${option.value}"
                      : "${option.label}"),
                  trailing: value == option.value
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).pop(option.value);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
