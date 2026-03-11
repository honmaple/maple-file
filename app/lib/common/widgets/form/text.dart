import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';

enum CustomListTileTextFieldType { number, string, password }

class CustomListTileTextField extends StatefulWidget {
  const CustomListTileTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.leading,
    this.subtitle,
    this.trailing,
    this.isRequired = false,
    this.controller,
    this.validator,
    this.type = CustomListTileTextFieldType.string,
  });

  final String? value;
  final bool isRequired;
  final String label;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final TextEditingController? controller;
  final CustomListTileTextFieldType type;
  final Function(String) onChanged;
  final FormFieldValidator<String>? validator;

  @override
  State<CustomListTileTextField> createState() =>
      _CustomListTileTextFieldState();
}

class _CustomListTileTextFieldState extends State<CustomListTileTextField> {
  late final TextEditingController _controller;

  late bool showObscureText;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }

    showObscureText = widget.type == CustomListTileTextFieldType.password;
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(widget.label),
              if (widget.isRequired)
                Text(' *', style: TextStyle(color: Colors.red)),
              SizedBox(width: 32),
            ],
          ),
          Flexible(
            child: FormField<String>(
              validator: widget.validator ??
                  (widget.isRequired
                      ? (value) {
                          if (value == null || value.isEmpty) {
                            return '{}不能为空'.tr(args: [widget.label]);
                          }
                          return null;
                        }
                      : null),
              initialValue: _controller.text,
              builder: (field) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IntrinsicWidth(
                      child: _buildField(context, field),
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      subtitle: widget.subtitle,
      trailing: widget.trailing == null
          ? null
          : Padding(
              padding: EdgeInsets.only(left: 16),
              child: widget.trailing,
            ),
    );
  }

  _buildField(BuildContext context, FormFieldState<String> field) {
    switch (widget.type) {
      case CustomListTileTextFieldType.string:
        return TextField(
          controller: _controller,
          textAlign: TextAlign.end,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: widget.label,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          onChanged: (result) {
            field.didChange(result);
            if (field.hasError) field.validate();

            widget.onChanged(result);
          },
        );
      case CustomListTileTextFieldType.number:
        return TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: widget.label,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            prefixIcon: GestureDetector(
              onTap: () {
                _controller.text = "${int.parse(_controller.text) - 1}";
                widget.onChanged(_controller.text);
              },
              child: Icon(Icons.remove),
            ),
            prefixIconConstraints: BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                _controller.text = "${int.parse(_controller.text) + 1}";
                widget.onChanged(_controller.text);
              },
              child: Icon(Icons.add),
            ),
            suffixIconConstraints: BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
          ),
          onChanged: (result) {
            field.didChange(result);
            if (field.hasError) field.validate();

            if (result.isEmpty) {
              widget.onChanged("0");
            } else {
              widget.onChanged(result);
            }
          },
        );
      case CustomListTileTextFieldType.password:
        return TextField(
          controller: _controller,
          textAlign: TextAlign.end,
          textAlignVertical: TextAlignVertical.center,
          obscureText: showObscureText,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: widget.label,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  showObscureText = !showObscureText;
                });
              },
              child: Icon(
                showObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
          ),
          onChanged: (result) {
            field.didChange(result);
            if (field.hasError) field.validate();

            widget.onChanged(result);
          },
        );
    }
  }
}
