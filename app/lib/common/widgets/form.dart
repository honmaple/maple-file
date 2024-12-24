import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/widgets/responsive.dart';

import 'dialog.dart';

class CustomFormFieldOption<T> {
  final String label;
  final T value;
  final Widget? trailing;

  const CustomFormFieldOption({
    required this.label,
    required this.value,
    this.trailing,
  });
}

enum CustomFormFieldType {
  string,
  number,
  password,
  directory,
  option,
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.options,
    this.type = CustomFormFieldType.string,
    this.subtitle,
    this.trailing,
    this.isRequired = false,
  });

  final bool isRequired;
  final String label;
  final String? value;
  final Widget? subtitle;
  final Widget? trailing;
  final List<CustomFormFieldOption>? options;
  final CustomFormFieldType type;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          const SizedBox(width: 16),
          Flexible(
            child: trailing ?? _emptyText(context, value),
          ),
        ],
      ),
      subtitle: subtitle,
      onTap: () async {
        String? result;
        switch (type) {
          case CustomFormFieldType.string:
            result = await showEditingDialog(
              context,
              label,
              value: value ?? "",
            );
            break;
          case CustomFormFieldType.number:
            result = await showNumberEditingDialog(
              context,
              label,
              value: value ?? "",
            );
            break;
          case CustomFormFieldType.password:
            result = await showPasswordEditingDialog(
              context,
              label,
              value: value ?? "",
            );
            break;
          case CustomFormFieldType.directory:
            result = await FilePicker.platform.getDirectoryPath();
            break;
          case CustomFormFieldType.option:
            result = await showListDialog(context, items: [
              for (final opt in options!)
                ListDialogItem(
                  label: opt.label,
                  value: opt.value,
                  trailing: opt.trailing,
                ),
            ]);
            break;
        }
        if (result != null) {
          onTap(result);
        }
      },
    );
  }

  Widget _emptyText(
    BuildContext context,
    String? value,
  ) {
    bool isEmpty = value == null || value == "";
    if (type == CustomFormFieldType.password) {
      if (!isEmpty) {
        return const Icon(Icons.more_horiz);
      }
    }
    final option = options?.where((o) => o.value == value);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          isEmpty ? "未设置".tr() : option?.firstOrNull?.label ?? value,
          maxLines: 1,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (isRequired && isEmpty)
          const Text(' *', style: TextStyle(color: Colors.red)),
        if (options != null) const Icon(Icons.chevron_right),
      ],
    );
  }
}

class FolderFormField extends StatelessWidget {
  const FolderFormField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.isRequired = false,
  });

  final bool isRequired;
  final String label;
  final String? value;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          const SizedBox(width: 16),
          Flexible(
            child: _emptyText(context, value),
          ),
        ],
      ),
      onTap: () async {
        final Map<String, dynamic> args = {
          "path": "/",
          "title": "选择$label",
          "filter": (file) => file.type == "DIR",
        };
        final result = await Navigator.pushNamed(
          context,
          '/file/select',
          arguments: args,
        );
        if (result != null) {
          onTap(result as String);
        }
      },
    );
  }

  Widget _emptyText(
    BuildContext context,
    String? value,
  ) {
    bool isEmpty = value == null || value == "";
    return Wrap(
      children: [
        Text(
          isEmpty ? "未设置".tr() : value,
          maxLines: 1,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (isRequired && isEmpty)
          const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}

class CustomFileType extends StatefulWidget {
  const CustomFileType({super.key, required this.types});

  final List<String> types;

  @override
  State<CustomFileType> createState() => _CustomFileTypeState();
}

class _CustomFileTypeState extends State<CustomFileType>
    with TickerProviderStateMixin {
  late TextEditingController _controller;

  late TabController _tabController;

  late List<String> _types;

  @override
  void initState() {
    super.initState();

    _types = List<String>.from(widget.types);

    _controller = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("文件类型".tr()),
        leading: Breakpoint.isMobile(context)
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        actions: [
          TextButton(
            child: Text("确定".tr()),
            onPressed: () {
              Navigator.of(context).pop(_types);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final type in _types)
                      InputChip(
                        label: Text(type),
                        labelStyle: TextStyle(
                          fontSize: kDefaultFontSize * 0.875,
                          color: Theme.of(context).primaryColor,
                        ),
                        selected: true,
                        showCheckmark: false,
                        onDeleted: () {
                          setState(() {
                            _types.remove(type);
                          });
                        },
                      )
                  ],
                ),
              ),
              if (_types.isNotEmpty)
                const SliverPadding(
                  padding: EdgeInsets.only(top: 8),
                ),
              SliverToBoxAdapter(
                child: TextField(
                  controller: _controller,
                  autofocus: false,
                  decoration: InputDecoration(
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '输入文件类型'.tr(),
                    hintStyle: const TextStyle(
                      fontSize: 12,
                    ),
                    prefixIcon: const Icon(Icons.tag),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 42,
                      minHeight: 42,
                    ),
                    filled: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 8),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('添加'.tr()),
                    onPressed: () {
                      final text = _controller.text;
                      if (text != "") {
                        setState(() {
                          _types.add(text);
                          _controller.text = "";
                        });
                      }
                    },
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 8),
              ),
              SliverToBoxAdapter(
                child: Card(
                  child: ListTile(
                    dense: true,
                    title: Text.rich(
                      TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(
                              Icons.error_outline,
                              size: 16,
                            ),
                          ),
                          const TextSpan(text: " "),
                          TextSpan(text: "语法规则".tr()),
                        ],
                      ),
                    ),
                    subtitle: Wrap(
                      direction: Axis.vertical,
                      spacing: 2,
                      children: [
                        Text("1. 包括文件: {file}".tr(args: {
                          "file": "abc.png、.png、*.png、abc*.png",
                        })),
                        Text("2. 包括目录: {file}".tr(args: {
                          "file": "abc/*.png、abc/**/*.png、*/**/abc*.png",
                        })),
                        Text("3. 排除文件或目录: {file}".tr(args: {
                          "file": "-abc.png、-*abc.png、-abc/**/*.png",
                        })),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(top: 8),
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: <Tab>[
                        Tab(text: "图片".tr()),
                        Tab(text: "视频".tr()),
                        Tab(text: "音频".tr()),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildList(context, PathUtil.imageTypes),
                          _buildList(context, PathUtil.videoTypes),
                          _buildList(context, PathUtil.audioTypes),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildList(BuildContext context, List<String> types) {
    Map<String, bool> typeMap = {};

    int length = 0;
    for (final type in types) {
      final b = _types.contains(type);
      if (b) length++;

      typeMap[type] = b;
    }
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Divider(height: 0.1, color: Colors.grey[300]);
      },
      itemCount: types.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            dense: true,
            title: Text(
              length == types.length ? "取消全选".tr() : "全选".tr(),
            ),
            trailing: length == types.length
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
            onTap: () {
              if (length == types.length) {
                for (final type in types) {
                  _types.remove(type);
                }
              } else {
                for (final type in types) {
                  if (!(typeMap[type] ?? false)) {
                    _types.add(type);
                  }
                }
              }
              setState(() {});
            },
          );
        }
        final type = types[index - 1];
        return ListTile(
          title: Text(type),
          trailing: typeMap[type] ?? false
              ? Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                )
              : null,
          onTap: () {
            setState(() {
              if (_types.contains(type)) {
                _types.remove(type);
              } else {
                _types.add(type);
              }
            });
          },
        );
      },
    );
  }
}

class FileTypeFormField extends StatelessWidget {
  const FileTypeFormField({
    super.key,
    required this.label,
    required this.onTap,
    this.value = const [],
    this.isRequired = false,
  });

  final bool isRequired;
  final String label;
  final List<String> value;
  final Function(List<String>) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          const SizedBox(width: 16),
          Flexible(
            child: _emptyText(context),
          ),
        ],
      ),
      onTap: () async {
        final result = await showListDialog2(
          context,
          child: CustomFileType(types: value),
        );
        if (result != null) {
          onTap(result);
        }
      },
    );
  }

  Widget _emptyText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            value.isEmpty ? "空".tr() : value.join(","),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }
}
