import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';

enum CustomListTilePromptType {
  string,
  number,
  password,
  path,
}

class CustomListTilePrompt extends StatefulWidget {
  const CustomListTilePrompt({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.leading,
    this.subtitle,
    this.trailing,
    this.isRequired = false,
    this.controller,
    this.type = CustomListTilePromptType.string,
  });

  final bool isRequired;
  final String label;
  final String? value;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final TextEditingController? controller;
  final CustomListTilePromptType type;
  final Function(String) onTap;

  @override
  State<CustomListTilePrompt> createState() => _CustomListTilePromptState();
}

class _CustomListTilePromptState extends State<CustomListTilePrompt> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: widget.leading,
      title: Row(
        children: [
          Text(widget.label),
          if (widget.isRequired)
            Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
      subtitle: widget.subtitle,
      trailing: widget.trailing ?? _buildTrailing(context),
      onTap: () async {
        String? result;
        switch (widget.type) {
          case CustomListTilePromptType.path:
            result = await showCustomEditingDialog(
              context: context,
              label: widget.label,
              value: widget.value ?? "",
              controller: _controller,
              helper: _buildPathFormat(context),
            );
            break;
          case CustomListTilePromptType.string:
            result = await showCustomEditingDialog(
              context: context,
              label: widget.label,
              value: widget.value ?? "",
            );
            break;
          case CustomListTilePromptType.number:
            result = await showCustomEditingDialog(
              context: context,
              label: widget.label,
              value: widget.value ?? "",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            );
            break;
          case CustomListTilePromptType.password:
            result = await showCustomEditingDialog(
              context: context,
              label: widget.label,
              value: widget.value ?? "",
              obscureText: true,
            );
            break;
        }
        if (result != null) {
          widget.onTap(result);
        }
      },
    );
  }

  Widget _buildTrailing(BuildContext context) {
    final isEmpty = widget.value == null || widget.value == "";
    if (widget.type == CustomListTilePromptType.password) {
      if (!isEmpty) {
        return const Icon(Icons.more_horiz);
      }
    }
    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            isEmpty ? "未设置".tr() : widget.value!,
            maxLines: 1,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          isMaterial(context)
              ? const Icon(Icons.chevron_right)
              : CupertinoListTileChevron(),
        ],
      ),
    );
  }

  Widget _buildPathFormat(BuildContext context) {
    Map<String, String> formats = {
      "文件分隔".tr(): "/",
      "文件路径".tr(): "{rawpath}",
      "文件名称".tr(): "{filename}",
      "文件扩展".tr(): "{extension}",
      "年".tr(): "{time:year}",
      "月".tr(): "{time:month}",
      "日".tr(): "{time:day}",
      "时".tr(): "{time:hour}",
      "分".tr(): "{time:minute}",
      "秒".tr(): "{time:second}",
    };
    return Wrap(
      spacing: 4,
      // runSpacing: 4,
      children: [
        for (final key in formats.keys)
          ActionChip(
            label: Text(key),
            labelStyle: TextStyle(
              fontSize: kDefaultFontSize * 0.875,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              final text = formats[key] ?? "";

              final offset = _controller.selection.base.offset;
              final prefix = _controller.text.substring(0, offset);
              final suffix = _controller.text.substring(offset);

              _controller.text = "$prefix$text$suffix";
              _controller.selection = TextSelection.collapsed(
                offset: offset + text.length,
              );
            },
          ),
      ],
    );
  }
}
