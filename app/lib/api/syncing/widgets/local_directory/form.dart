import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path/path.dart' as filepath;
import 'package:permission_handler/permission_handler.dart';

import 'package:maple_file/api/file/providers/repo.dart';
import 'package:maple_file/api/file/widgets/file_select.dart';
import 'package:maple_file/api/syncing/providers/local_directory/profile.dart';
import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class LocalDirectorySyncForm extends ConsumerStatefulWidget {
  const LocalDirectorySyncForm({super.key, this.profile});

  final SyncProfile? profile;

  @override
  ConsumerState<LocalDirectorySyncForm> createState() =>
      _LocalDirectorySyncFormState();
}

class _LocalDirectorySyncFormState
    extends ConsumerState<LocalDirectorySyncForm> {
  final _formKey = GlobalKey<FormState>();
  late LocalDirectorySyncProfile _form;

  @override
  void initState() {
    super.initState();
    _form = widget.profile == null
        ? LocalDirectorySyncProfile.create(
            name: SyncSourceType.localDirectory.label,
          )
        : LocalDirectorySyncProfile.fromSyncProfile(widget.profile!);
  }

  bool get _isEditing => _form.id > 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            children: [
              CustomListTileTextField(
                label: '同步名称'.tr(),
                value: _form.name,
                isRequired: true,
                onChanged: (value) =>
                    setState(() => _form = _form.copyWith(name: value)),
              ),
              CustomListTileSwitch(
                label: '自动同步'.tr(),
                value: _form.enabled,
                onChanged: (value) =>
                    setState(() => _form = _form.copyWith(enabled: value)),
              ),
            ],
          ),
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            children: [
              PlatformListTile(
                title: Text('本地来源目录'.tr()),
                subtitle: Text(
                  _form.sourceConfig.path.isEmpty
                      ? '未选择'.tr()
                      : _form.sourceConfig.path,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: SyncSourceType.localDirectory.isSupported
                    ? _handleSelectSource
                    : null,
              ),
              PlatformListTile(
                title: Text('云端目标目录'.tr()),
                subtitle: Text(
                  _form.targetConfig.path.isEmpty
                      ? '未选择'.tr()
                      : _form.targetConfig.path,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: _handleSelectTarget,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _handleSave,
              child: Text(_isEditing ? '确认修改'.tr() : '确认添加'.tr()),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSelectSource() async {
    try {
      if (Util.isAndroid) {
        final permission = await Permission.manageExternalStorage.request();
        if (!permission.isGranted) {
          throw StateError('需要“所有文件访问权限”才能选择本地目录');
        }
      }
      final selected = await FilePicker.platform.getDirectoryPath(
        dialogTitle: '选择本地来源目录'.tr(),
      );
      if (selected == null || !mounted) return;
      final path = filepath.normalize(filepath.absolute(selected));
      var bookmark = '';
      if (Util.isMacOS) {
        bookmark = await SecureBookmarks().bookmark(io.Directory(path));
      }
      if (!mounted) return;
      setState(() {
        _form = _form.copyWith(
          sourceConfig: _form.sourceConfig.copyWith(
            path: path,
            bookmark: bookmark,
          ),
        );
      });
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  Future<void> _handleSelectTarget() async {
    try {
      final repositories = await RepoService.instance.list();
      final localRoots = SyncTargetRepository.localRoots(repositories);
      if (!mounted) return;
      final selected = await showDirectorySelectDialog(
        context,
        path: _form.targetConfig.path.isEmpty ? '/' : _form.targetConfig.path,
        title: '选择云端目标目录'.tr(),
        filter: (File file) {
          final path = filepath.posix.normalize(
            filepath.posix.join(file.path, file.name),
          );
          return !localRoots.contains(path);
        },
      );
      if (selected == null || !mounted) return;
      await SyncTargetRepository.requireRemote(selected);
      if (!mounted) return;
      setState(() {
        _form = _form.copyWith(
          targetConfig: _form.targetConfig.copyWith(path: selected),
        );
      });
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_form.sourceConfig.path.isEmpty || _form.targetConfig.path.isEmpty) {
      SmartDialog.showNotify(
        msg: '请选择本地来源目录和云端目标目录'.tr(),
        notifyType: NotifyType.warning,
      );
      return;
    }
    try {
      await SyncTargetRepository.requireRemote(_form.targetConfig.path);
      final profile = _isEditing
          ? await SyncingService.instance.updateProfile(_form.toSyncProfile())
          : await SyncingService.instance.createProfile(_form.toSyncProfile());
      ref.invalidate(syncProfilesProvider);
      if (mounted) Navigator.pop(context, profile);
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }
}
