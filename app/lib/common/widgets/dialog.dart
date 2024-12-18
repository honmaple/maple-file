import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/responsive.dart';

class CustomEditingDialog extends StatefulWidget {
  const CustomEditingDialog({
    super.key,
    required this.label,
    this.value,
    this.helper,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.selection,
    this.controller,
  });

  final String label;
  final String? value;
  final bool obscureText;
  final Widget? helper;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextSelection? selection;
  final TextEditingController? controller;

  @override
  State<CustomEditingDialog> createState() => _CustomEditingDialogState();
}

class _CustomEditingDialogState extends State<CustomEditingDialog> {
  late final TextEditingController _controller;

  late bool showObscureText;

  @override
  void initState() {
    super.initState();

    showObscureText = widget.obscureText;
    _controller = widget.controller ?? TextEditingController();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
    if (widget.selection != null) {
      _controller.selection = widget.selection!;
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
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      title: Text(widget.label, style: const TextStyle(fontSize: 18)),
      content: TextFormField(
        controller: _controller,
        autofocus: true,
        obscureText: showObscureText,
        enableInteractiveSelection: true,
        onSaved: null,
        minLines: 1,
        maxLines: widget.obscureText ? 1 : 3,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          helper: widget.helper,
          isDense: true,
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      showObscureText = !showObscureText;
                    });
                  },
                  child: Icon(showObscureText
                      ? Icons.visibility_off
                      : Icons.visibility),
                )
              : null,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('确认'),
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
        ),
      ],
    );
  }
}

class DialogOption<T> {
  final IconData? icon;
  final String? label;
  final T? value;
  final Widget? child;
  final Widget? trailing;

  DialogOption({
    this.icon,
    this.label,
    this.value,
    this.child,
    this.trailing,
  }) : assert(child != null || value != null,
            "child and value can't Cannot be null at the same time");
}

class ListDialogItem<T> {
  final IconData? icon;
  final String? label;
  final T? value;
  final Widget? child;
  final Widget? trailing;

  ListDialogItem({
    this.icon,
    this.label,
    this.value,
    this.child,
    this.trailing,
  }) : assert(child != null || value != null,
            "child and value can't Cannot be null at the same time");

  // static Widget from({
  //   IconData? icon,
  //   String? label,
  //   T? value,
  //   Widget? child,
  //   Widget? trailing,
  // }) {
  //   return ListTile(
  //     leading: icon != null
  //         ? Icon(
  //             icon,
  //             color: ColorUtil.backgroundColorWithString("${value}"),
  //           )
  //         : null,
  //     title: Text(label == null ? "${value}" : "${label}"),
  //     titleAlignment: ListTileTitleAlignment.center,
  //     trailing: trailing,
  //     onTap: () {
  //       Navigator.of(context).pop(item.value);
  //     },
  //   );
  // }
}

List<Widget> _dialogChildren<T>(
  BuildContext context, {
  List<ListDialogItem<T>>? items,
  bool cancelAction = false,
}) {
  List<Widget> children = [];
  if (items != null) {
    children = items.map((item) {
      return item.child ??
          ListTile(
            leading: item.icon != null
                ? Icon(
                    item.icon,
                    color: ColorUtil.backgroundColorWithString(
                        item.label == null ? "${item.value}" : item.label!),
                  )
                : null,
            title: Text(item.label == null ? "${item.value}" : "${item.label}"),
            titleAlignment: ListTileTitleAlignment.center,
            trailing: item.trailing,
            onTap: () {
              Navigator.of(context).pop(item.value);
            },
          );
    }).toList();
  }

  if (cancelAction) {
    children.add(ListTile(
      leading: const Icon(Icons.cancel),
      title: const Text('取消'),
      onTap: () {
        Navigator.pop(context);
      },
    ));
  }
  return children;
}

Future<T?> showListDialog<T>(
  BuildContext context, {
  List<ListDialogItem<T>>? items,
  bool center = false,
  bool cancelAction = false,
  double? height,
}) {
  return showListDialog2(
    context,
    height: height,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _dialogChildren(
          context,
          items: items,
          cancelAction: cancelAction,
        ),
      ),
    ),
  );
}

Future<T?> showListDialog2<T>(
  BuildContext context, {
  Widget? child,
  double? width,
  double? height,
}) {
  if (Breakpoint.isMobile(context)) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final maxHeight =
            MediaQuery.of(context).size.height - kTextTabBarHeight;
        return Container(
          constraints: BoxConstraints(
            maxHeight: math.min(
              maxHeight,
              (height ?? maxHeight) + MediaQuery.of(context).viewInsets.bottom,
            ),
          ),
          child: child,
        );
      },
    );
  }
  return showDialog<T>(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) {
      return AlertDialog(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      );
    },
  );
}

Future<bool?> showAlertDialog<T>(BuildContext context,
    {Widget? title, Widget? content}) {
  return showDialog<bool>(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        title: title,
        content: content,
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('确认'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<T?> showEditingDialog<T>(
  BuildContext context,
  String label, {
  String? value,
  TextSelection? selection,
  TextEditingController? controller,
  bool obscureText = false,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  Widget? helper,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return CustomEditingDialog(
        label: label,
        value: value,
        helper: helper,
        selection: selection,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      );
    },
  );
}

Future<T?> showNumberEditingDialog<T>(
  BuildContext context,
  String label, {
  String? value,
  TextEditingController? controller,
}) {
  return showEditingDialog(
    context,
    label,
    value: value,
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
  );
}

Future<T?> showPasswordEditingDialog<T>(
  BuildContext context,
  String label, {
  String? value,
  TextEditingController? controller,
}) {
  return showEditingDialog(
    context,
    label,
    value: value,
    controller: controller,
    obscureText: true,
  );
}

Future<T?> showTopModalSheet<T>(
  BuildContext context,
  Widget child, {
  bool barrierDismissible = true,
  BorderRadiusGeometry? borderRadius,
  Duration transitionDuration = const Duration(milliseconds: 250),
  Color? backgroundColor,
  Color barrierColor = const Color(0x80000000),
  Offset startOffset = const Offset(0, -0.5),
  Curve curve = Curves.easeOutCubic,
}) {
  return showGeneralDialog<T?>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration,
    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
    barrierColor: barrierColor,
    pageBuilder: (context, _, __) => child,
    transitionBuilder: (context, animation, _, child) {
      return SlideTransition(
        position: CurvedAnimation(parent: animation, curve: curve)
            .drive(Tween<Offset>(begin: startOffset, end: Offset.zero)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: backgroundColor,
              borderRadius: borderRadius,
              clipBehavior: Clip.antiAlias,
              child: child,
            )
          ],
        ),
      );
    },
  );
}
