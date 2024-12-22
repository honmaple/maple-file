import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/path.dart';

import 'dialog.dart';

class CustomFormFieldOption<T> {
  final String label;
  final T value;

  const CustomFormFieldOption({required this.label, required this.value});
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
    this.isRequired = false,
  });

  final bool isRequired;
  final String label;
  final String? value;
  final Widget? subtitle;
  final List<CustomFormFieldOption>? options;
  final CustomFormFieldType type;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: subtitle,
      trailing: _emptyText(context, value),
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
                ListDialogItem(label: opt.label, value: opt.value),
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
          isEmpty ? "未设置".tr(context) : option?.firstOrNull?.label ?? value,
          overflow: TextOverflow.ellipsis,
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
          isEmpty ? "未设置".tr(context) : value,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
        if (isRequired && isEmpty)
          const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}

class FileTypeFormField extends StatefulWidget {
  const FileTypeFormField({super.key, required this.types});

  final List<String> types;

  @override
  State<FileTypeFormField> createState() => _FileTypeFormFieldState();
}

class _FileTypeFormFieldState extends State<FileTypeFormField>
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
        title: Text("文件类型".tr(context)),
        actions: [
          TextButton(
            child: Text("确定".tr(context)),
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
              SliverToBoxAdapter(
                child: TextField(
                  controller: _controller,
                  autofocus: false,
                  decoration: InputDecoration(
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '输入文件类型'.tr(context),
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
                    child: Text('添加'.tr(context)),
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
                          TextSpan(text: "语法规则".tr(context)),
                        ],
                      ),
                    ),
                    subtitle: Wrap(
                      direction: Axis.vertical,
                      spacing: 2,
                      children: [
                        Text("1. 包括文件: {file}".tr(context, args: {
                          "file": "abc.png、.png、*.png、abc*.png",
                        })),
                        Text("2. 包括目录: {file}".tr(context, args: {
                          "file": "abc/*.png、abc/**/*.png、*/**/abc*.png",
                        })),
                        Text("3. 排除文件或目录: {file}".tr(context, args: {
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
                        Tab(text: "图片".tr(context)),
                        Tab(text: "视频".tr(context)),
                        Tab(text: "音频".tr(context)),
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
              length == types.length ? "取消全选".tr(context) : "全选".tr(context),
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
