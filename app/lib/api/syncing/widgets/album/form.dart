import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/api/file/widgets/file_select.dart';
import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/api/syncing/widgets/album/select.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class AlbumBackupForm extends ConsumerStatefulWidget {
  const AlbumBackupForm({super.key, this.profile});

  final SyncProfile? profile;

  @override
  ConsumerState<AlbumBackupForm> createState() => _AlbumBackupFormState();
}

class _AlbumBackupFormState extends ConsumerState<AlbumBackupForm> {
  final _formKey = GlobalKey<FormState>();

  late AlbumBackupProfile _form;
  List<_AlbumSource>? _selectedSources;
  Map<String, String> _albumNames = {};

  @override
  void initState() {
    super.initState();
    _form = widget.profile == null
        ? AlbumBackupProfile.create(name: SyncSourceType.album.label)
        : AlbumBackupProfile.fromSyncProfile(widget.profile!);
    if (Util.isAndroid || Util.isIOS) {
      _handleLoadAlbumNames();
    }
  }

  Future<void> _handleLoadAlbumNames() async {
    try {
      final albums =
          await AlbumBackupService.instance.requestAlbums(includeEmpty: true);
      if (mounted) {
        setState(() =>
            _albumNames = {for (final album in albums) album.id: album.name});
      }
    } catch (_) {
      // Album selection will request permission when opened.
    }
  }

  bool get _isEditing => _form.id > 0;

  @override
  Widget build(BuildContext context) {
    return _buildForm(_selectedSources ?? _albumSources());
  }

  Widget _buildForm(List<_AlbumSource> sources) {
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
                label: '备份名称'.tr(),
                value: _form.name,
                isRequired: true,
                onChanged: (value) =>
                    setState(() => _form = _form.copyWith(name: value)),
              ),
              CustomListTileSwitch(
                label: '自动备份'.tr(),
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
                title: Text('备份相册'.tr()),
                subtitle: Text(
                  sources.isEmpty
                      ? '未选择'.tr()
                      : sources.map((source) => source.name).join('、'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: () => _handleSelectAlbums(sources),
              ),
              PlatformListTile(
                title: Text('备份目标'.tr()),
                subtitle: Text(
                  _targetPath.isEmpty ? '未选择'.tr() : _targetPath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: _handleSelectTarget,
              ),
              CustomListTileSwitch(
                label: '自动添加手机型号'.tr(),
                subtitle: Text('在所选目录下创建手机型号子目录'.tr()),
                value: _appendDeviceModelEnabled,
                onChanged: _handleToggleDeviceModel,
              ),
            ],
          ),
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            children: [
              PlatformListTile(
                title: Text('目的地整理'.tr()),
                subtitle: Text(
                  _layout.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: _handleSelectLayout,
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
              onPressed: () => _handleSave(sources),
              child: Text(_isEditing ? '确认修改'.tr() : '确认添加'.tr()),
            ),
          ),
        ],
      ),
    );
  }

  String get _targetPath => _form.targetConfig.path;

  AlbumTargetLayout get _layout => _form.targetConfig.layout;

  bool get _appendDeviceModelEnabled => _form.targetConfig.appendDeviceModel;

  void _handleUpdateTargetConfig({
    String? path,
    AlbumTargetLayout? layout,
    bool? appendDeviceModel,
  }) {
    _form = _form.copyWith(
      targetConfig: _form.targetConfig.copyWith(
        path: path ?? _form.targetConfig.path,
        layout: layout ?? _form.targetConfig.layout,
        appendDeviceModel:
            appendDeviceModel ?? _form.targetConfig.appendDeviceModel,
      ),
    );
  }

  Future<void> _handleSelectTarget() async {
    final selectedPath = await showDirectorySelectDialog(
      context,
      path: _targetPath.isEmpty ? '/' : _targetPath,
      title: '选择备份目录'.tr(),
    );
    if (selectedPath != null && mounted) {
      setState(() => _handleUpdateTargetConfig(path: selectedPath));
    }
  }

  Future<String> _removeDeviceModel(String path) async {
    final model = await albumBackupDeviceModel();
    if (model.isEmpty || filepath.posix.basename(path) != model) return path;
    return filepath.posix.dirname(path);
  }

  Future<void> _handleToggleDeviceModel(bool enabled) async {
    var path = _targetPath;
    if (!enabled && path.isNotEmpty) {
      path = await _removeDeviceModel(path);
    }
    if (!mounted) return;
    setState(() => _handleUpdateTargetConfig(
          path: path,
          appendDeviceModel: enabled,
        ));
  }

  Future<void> _handleSelectAlbums(List<_AlbumSource> sources) async {
    final selected = await showAlbumSelect(
      context,
      selectedIds: sources.map((source) => source.albumId).toSet(),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _albumNames = {for (final album in selected) album.id: album.name};
      _selectedSources = [
        for (final album in selected) _AlbumSource(album.id, album.name),
      ];
    });
  }

  Future<void> _handleSelectLayout() async {
    final layout = await showCustomListOptions<AlbumTargetLayout>(
      context: context,
      options: [
        CustomOption(
          label: '按年月日整理'.tr(),
          value: AlbumTargetLayout.yearMonthDay,
        ),
        CustomOption(
          label: '按年月整理'.tr(),
          value: AlbumTargetLayout.yearMonth,
        ),
        CustomOption(
          label: '文件名加资产 ID'.tr(),
          value: AlbumTargetLayout.filenameAssetId,
        ),
      ],
    );
    if (layout != null && mounted) {
      setState(() => _handleUpdateTargetConfig(layout: layout));
    }
  }

  Future<SyncProfile?> _handleSaveProfile(List<_AlbumSource> sources) async {
    if (!_formKey.currentState!.validate()) return null;
    if (_targetPath.isEmpty || sources.isEmpty) {
      SmartDialog.showNotify(
        msg: '请选择备份相册和备份目录'.tr(),
        notifyType: NotifyType.warning,
      );
      return null;
    }
    try {
      _form = _form.copyWith(
        sourceConfig: _form.sourceConfig.copyWith(
          albumIds: [for (final source in sources) source.albumId],
        ),
      );
      final profile = _isEditing
          ? await SyncingService.instance.updateProfile(_form.toSyncProfile())
          : await SyncingService.instance.createProfile(_form.toSyncProfile());
      _form = AlbumBackupProfile.fromSyncProfile(profile);
      ref.invalidate(syncProfilesProvider);
      return profile;
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
      return null;
    }
  }

  Future<void> _handleSave(List<_AlbumSource> sources) async {
    final profile = await _handleSaveProfile(sources);
    if (profile != null && mounted) Navigator.pop(context, profile);
  }

  List<_AlbumSource> _albumSources() {
    return [
      for (final id in _form.sourceConfig.albumIds)
        _AlbumSource(id, _albumNames[id] ?? id),
    ];
  }
}

class _AlbumSource {
  const _AlbumSource(this.albumId, this.name);

  final String albumId;
  final String name;
}
