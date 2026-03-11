import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/responsive.dart';

class CustomOption<T> {
  CustomOption({
    this.icon,
    this.label,
    this.value,
    this.child,
    this.trailing,
  }) : assert(child != null || value != null,
            "child and value can't Cannot be null at the same time");

  final Widget? icon;
  final String? label;
  final T? value;
  final Widget? child;
  final Widget? trailing;
}

class CustomConfirmDialog extends StatefulWidget {
  const CustomConfirmDialog({
    super.key,
    this.title,
    this.content,
    this.onCancel,
    this.onConfirm,
  });

  final Widget? title;
  final Widget? content;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  @override
  State<CustomConfirmDialog> createState() => _CustomConfirmDialogState();
}

class _CustomConfirmDialogState extends State<CustomConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    if (isMaterial(context)) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        title: widget.title,
        content: widget.content,
        actions: <Widget>[
          TextButton(
            onPressed: widget.onCancel ??
                () {
                  Navigator.of(context).pop();
                },
            child: Text('取消'.tr()),
          ),
          TextButton(
            onPressed: widget.onConfirm ??
                () {
                  Navigator.of(context).pop(true);
                },
            child: Text('确认'.tr()),
          ),
        ],
      );
    }
    return CupertinoAlertDialog(
      title: widget.title,
      content: widget.content,
      actions: [
        CupertinoDialogAction(
          onPressed: widget.onCancel ??
              () {
                Navigator.of(context).pop();
              },
          child: Text("取消".tr()),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: widget.onConfirm ??
              () {
                Navigator.of(context).pop(true);
              },
          child: Text("确认".tr()),
        ),
      ],
    );
  }
}

class CustomEditingDialog extends StatefulWidget {
  const CustomEditingDialog({
    super.key,
    required this.label,
    this.value,
    this.helper,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.decoration,
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
  final InputDecoration? decoration;

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
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _controller,
          autofocus: true,
          obscureText: showObscureText,
          enableInteractiveSelection: true,
          onSaved: null,
          minLines: 1,
          maxLines: widget.obscureText ? 1 : 1,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: widget.decoration ??
              InputDecoration(
                isDense: !isMaterial(context),
                border: const OutlineInputBorder(),
                labelText: widget.label,
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
        if (widget.helper != null) widget.helper!,
      ],
    );
    return CustomConfirmDialog(
      content: content,
      onConfirm: () {
        Navigator.of(context).pop(_controller.text);
      },
    );
  }
}

class CustomEditingBuilder extends StatefulWidget {
  const CustomEditingBuilder({
    super.key,
    this.value,
    this.selection,
    this.controller,
    required this.builder,
  });

  final String? value;
  final TextSelection? selection;
  final TextEditingController? controller;
  final Widget Function(BuildContext, TextEditingController) builder;

  @override
  State<CustomEditingBuilder> createState() => _CustomEditingBuilderState();
}

class _CustomEditingBuilderState extends State<CustomEditingBuilder> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

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
    return widget.builder(context, _controller);
  }
}

Future<T?> showCustomDialog<T>(
  BuildContext context, {
  Widget? child,
  double? width,
  double? height,
  bool useAlertDialog = false,
  bool useRootNavigator = false,
}) {
  if (Breakpoint.isSmall(context)) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: useRootNavigator,
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
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      if (useAlertDialog) {
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
      }
      return Dialog(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      );
    },
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

Future<bool?> showCustomConfirmDialog({
  required BuildContext context,
  Widget? title,
  Widget? content,
  bool useRootNavigator = true,
}) {
  return showPlatformDialog<bool>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      return CustomConfirmDialog(
        title: title,
        content: content,
      );
    },
  );
}

Future<String?> showCustomEditingDialog<T>({
  required BuildContext context,
  required String label,
  String? value,
  TextSelection? selection,
  TextEditingController? controller,
  bool obscureText = false,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  Widget? helper,
}) {
  if (isMaterial(context)) {
    return showDialog<String>(
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
  return showCupertinoDialog<String>(
    context: context,
    builder: (context) {
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

Future<String?> showCustomTextField({
  required BuildContext context,
  Widget? title,
  bool useRootNavigator = true,
  String? value,
  TextSelection? selection,
  TextEditingController? controller,
  required Widget Function(BuildContext, TextEditingController) builder,
}) {
  return showPlatformDialog<String>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      return CustomEditingBuilder(
        value: value,
        selection: selection,
        controller: controller,
        builder: (context, controller) {
          return CustomConfirmDialog(
            title: title,
            content: builder(context, controller),
            onConfirm: () {
              Navigator.of(context).pop(controller.text);
            },
          );
        },
      );
    },
  );
}

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showPlatformDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    cupertino: (context, _) {
      return CupertinoDatePickerData(
        doneLabel: "确认".tr(),
        cancelLabel: "取消".tr(),
      );
    },
  );
}

Future<T?> showCustomListOptions<T>({
  required BuildContext context,
  required List<CustomOption> options,
  double? height,
  bool useMaterial = false,
  bool cancelAction = true,
}) {
  if (useMaterial || isMaterial(context)) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in options)
                  option.child ??
                      ListTile(
                        leading: option.icon,
                        title: Text(option.label == null
                            ? "${option.value}"
                            : "${option.label}"),
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: () {
                          Navigator.of(context).pop(option.value);
                        },
                      ),
                if (cancelAction)
                  ListTile(
                    leading: Icon(Icons.cancel),
                    title: Text('取消'.tr()),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  return showCupertinoModalPopup<T>(
    context: context,
    builder: (context) {
      return SizedBox(
        height: height,
        child: CupertinoActionSheet(
          actions: <Widget>[
            for (final option in options)
              option.child ??
                  CupertinoActionSheetAction(
                    child: Text(option.label == null
                        ? "${option.value}"
                        : "${option.label}"),
                    onPressed: () {
                      Navigator.of(context).pop(option.value);
                    },
                  ),
          ],
          cancelButton: cancelAction
              ? CupertinoActionSheetAction(
                  child: Text('取消'.tr()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : null,
        ),
      );
    },
  );
}
