import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomListTileSwitch extends StatelessWidget {
  const CustomListTileSwitch({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.leading,
    this.subtitle,
    this.trailing,
    this.isRequired = false,
  });

  final bool isRequired;
  final String label;
  final bool? value;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: leading,
      title: Text(label),
      subtitle: subtitle,
      trailing: PlatformSwitch(
        value: value ?? false,
        activeTrackColor: Theme.of(context).primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
