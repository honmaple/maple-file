import 'package:maple_file/api/file/providers/service.dart';
import 'package:path/path.dart' as filepath;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../widgets/file_view.dart';

import '../providers/file.dart';

class FileSelect extends ConsumerStatefulWidget {
  final String path;
  final String title;
  final bool multiple;
  final bool Function(File)? filter;

  const FileSelect({
    super.key,
    this.path = "/",
    this.title = "选择文件",
    this.filter,
    this.multiple = false,
  });

  factory FileSelect.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;
    if (args == null) {
      return const FileSelect();
    }
    final map = args as Map<String, dynamic>;
    return FileSelect(
      path: map["path"] ?? "/",
      title: map["title"] ?? "选择文件",
      filter: map["filter"],
      multiple: map["multiple"] ?? false,
    );
  }

  @override
  ConsumerState<FileSelect> createState() => _FileSelectState();
}

class _FileSelectState extends ConsumerState<FileSelect> {
  @override
  Widget build(BuildContext context) {
    final selection = ref.watch(fileSelectionProvider);

    return Scaffold(
      appBar: buildAppBar(context),
      body: FileView(
        path: widget.path,
        filter: widget.filter,
        selection: selection,
        onTap: _onTap,
      ),
      bottomNavigationBar: widget.path != "/" ? buildBottomBar(context) : null,
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _resetProvider();

          Navigator.popUntil(context, (route) {
            return route.settings.name != "/file/select";
          });
        },
      ),
      actions: [
        if (widget.path != "/")
          TextButton(
            child: const Text("新建"),
            onPressed: () async {
              final result = await showEditingDialog(
                context,
                "新建文件夹".tr(),
              );
              if (result != null) {
                FileService().mkdir(widget.path, result).then((_) {
                  ref.invalidate(fileProvider(widget.path));
                });
              }
            },
          ),
      ],
    );
  }

  buildBottomBar(BuildContext context) {
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // icon: Icon(Icons.folder),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              List<String> list = widget.path.split('/');

              final result = ref
                  .read(fileSelectionProvider)
                  .selected
                  .map((file) => filepath.posix.join(file.path, file.name))
                  .toList();

              _resetProvider();

              final nav = Navigator.of(context);
              for (int i = 0; i < list.length; i++) {
                if (widget.multiple) {
                  nav.pop(result);
                } else {
                  nav.pop(widget.path);
                }
              }
            },
            child: const Text('确定'),
          ),
        ),
      ],
    );
  }

  _onTap(BuildContext context, File item) async {
    if (item.type == "DIR") {
      final Map<String, dynamic> args = {
        "path": filepath.posix.join(item.path, item.name),
        "title": widget.title,
        "filter": widget.filter,
        "multiple": widget.multiple,
      };
      Navigator.pushNamed(
        context,
        '/file/select',
        arguments: args,
      );
      return;
    }

    if (!ref.read(fileSelectionProvider).enabled) {
      ref.read(fileSelectionProvider.notifier).update((state) {
        return state.copyWith(
          enabled: true,
          multiple: widget.multiple,
        );
      });
    }
    ref.read(fileSelectionProvider.notifier).toggle(item);
  }

  _resetProvider() {
    ref.read(fileSelectionProvider.notifier).update((state) {
      return state.copyWith(
        enabled: false,
        multiple: true,
        selected: [],
      );
    });
  }
}
