import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';

abstract class CustomListTileBase<T> extends StatelessWidget {
  const CustomListTileBase({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.leading,
    this.subtitle,
    this.trailing,
    this.isRequired = false,
  });

  final bool isRequired;
  final String label;
  final T? value;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final Function(T) onTap;

  buildTrailing(
    BuildContext context, {
    bool showChevron = false,
  }) {
    final isEmpty = value == null || value == "";
    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            isEmpty ? "未设置".tr() : buildTrailingValue(),
            maxLines: 1,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (isRequired && isEmpty)
            const Text(' *', style: TextStyle(color: Colors.red)),
          if (showChevron)
            isMaterial(context)
                ? const Icon(Icons.chevron_right)
                : CupertinoListTileChevron(),
        ],
      ),
    );
  }

  bool get isEmpty => value == "" || value == "";

  String buildTrailingValue() {
    return "$value";
  }
}
