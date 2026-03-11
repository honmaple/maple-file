import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/widgets/dialog.dart';

import 'common.dart';

class CustomListTileDateTime extends CustomListTileBase<DateTime> {
  const CustomListTileDateTime({
    super.key,
    required super.label,
    required super.onTap,
    super.value,
    super.leading,
    super.subtitle,
    super.trailing,
    super.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      title: Text(label),
      leading: leading,
      subtitle: subtitle,
      trailing: trailing ?? buildTrailing(context, showChevron: true),
      onTap: () async {
        final result = await showCustomDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2030),
        );
        if (result != null) {
          onTap(result);
        }
      },
    );
  }

  @override
  String buildTrailingValue() {
    return TimeUtil.dateToString(value!);
  }
}
