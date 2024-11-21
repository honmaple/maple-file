import 'package:flutter/material.dart';
import 'dialog.dart';

typedef CustomGestureTapCallback = void Function(String value);

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.isRequired = false,
    this.obscureText = false,
    this.onTap,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
  final bool isRequired;
  final Widget? title;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final CustomGestureTapCallback? onTap;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _trailing() {
    if (widget.trailing == null) {
      if (widget.value == "") {
        if (widget.isRequired) {
          return const Wrap(
            children: [
              Text("未设置"),
              Text(' *', style: TextStyle(color: Colors.red)),
            ],
          );
        }
        return const Text("未设置");
      }
      if (widget.obscureText) {
        return const Icon(Icons.more_horiz);
      }
      return Text(widget.value);
    }
    return widget.trailing;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading,
      title: widget.title == null ? Text(widget.label) : null,
      trailing: _trailing(),
      onTap: () async {
        if (widget.onTap != null) {
          final result =
              await showCustomDialog(context, widget.label, widget.value);
          if (result != null) {
            widget.onTap!(result);
          }
        }
      },
    );
  }

  showCustomDialog<T>(BuildContext context, String label, T? value) async {
    if (value != null) {
      value as String;
      _textController.text = value;
    } else {
      _textController.text = "";
    }
    return showEditingDialog(
      context,
      label,
      controller: _textController,
      obscureText: widget.obscureText,
    );
  }
}
