import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/api/file/widgets/directory_select.dart';
import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/api/syncing/widgets/album_select.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class AlbumBackupEditScreen extends ConsumerStatefulWidget {
  const AlbumBackupEditScreen({super.key, this.profile});

  final SyncProfile? profile;

  factory AlbumBackupEditScreen.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;
    return AlbumBackupEditScreen(profile: args as SyncProfile?);
  }

  @override
  ConsumerState<AlbumBackupEditScreen> createState() =>
      _AlbumBackupEditScreenState();
}

class _AlbumBackupEditScreenState extends ConsumerState<AlbumBackupEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late SyncProfile _form;
  List<_AlbumSource>? _selectedSources;
  Map<String, String> _albumNames = {};

  @override
  void initState() {
    super.initState();
    _form = widget.profile == null
        ? SyncProfile(
            name: '相册备份'.tr(),
            enabled: true,
            mode: SyncProfile_Mode.MODE_BACKUP,
            sourceType: SyncSourceType.album.value,
            sourceConfig: jsonEncode({'album_ids': <String>[]}),
            targetType: SyncTargetType.repoDirectory.value,
            targetConfig: jsonEncode({
              'path': '',
              'layout': AlbumDestinationLayout.yearMonthDay.value,
              'append_device_model': true,
            }),
            policyConfig: '{}',
          )
        : (SyncProfile()..mergeFromMessage(widget.profile!));
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
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text(_isEditing ? '修改相册备份'.tr() : '添加相册备份'.tr()),
        trailingActions: [
          if (_isEditing)
            TextButton(onPressed: _handleDelete, child: Text('删除'.tr())),
        ],
      ),
      body: _buildForm(_selectedSources ?? _albumSources()),
    );
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
                onChanged: (value) => setState(() => _form.name = value),
              ),
              CustomListTileSwitch(
                label: '启用备份'.tr(),
                value: _form.enabled,
                onChanged: (value) => setState(() => _form.enabled = value),
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
                  _layout.label.tr(),
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
              onPressed: () => _handleSave(sources),
              child: Text(_isEditing ? '确认修改'.tr() : '确认添加'.tr()),
            ),
          ),
        ],
      ),
    );
  }

  String get _targetPath => _json(_form.targetConfig)['path'] as String? ?? '';

  AlbumDestinationLayout get _layout => AlbumDestinationLayout.fromValue(
        _json(_form.targetConfig)['layout'] as String?,
      );

  bool get _appendDeviceModelEnabled =>
      _json(_form.targetConfig)['append_device_model'] as bool? ?? true;

  void _handleUpdateTargetConfig({
    String? path,
    AlbumDestinationLayout? layout,
    bool? appendDeviceModel,
  }) {
    _form.targetConfig = jsonEncode({
      'path': path ?? _targetPath,
      'layout': (layout ?? _layout).value,
      'append_device_model': appendDeviceModel ?? _appendDeviceModelEnabled,
    });
  }

  Future<void> _handleSelectTarget() async {
    final selectedPath = await showCustomDialog<String>(
      context,
      width: 560,
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: FileDirectorySelect(title: '选择备份目录'.tr()),
    );
    if (selectedPath != null && mounted) {
      final path = _appendDeviceModelEnabled
          ? await _appendDeviceModel(selectedPath)
          : selectedPath;
      if (!mounted) return;
      setState(() => _handleUpdateTargetConfig(path: path));
    }
  }

  Future<String> _appendDeviceModel(String path) async {
    final model = await _deviceModel();
    if (model.isEmpty || filepath.posix.basename(path) == model) return path;
    return filepath.posix.join(path, model);
  }

  Future<String> _removeDeviceModel(String path) async {
    final model = await _deviceModel();
    if (model.isEmpty || filepath.posix.basename(path) != model) return path;
    return filepath.posix.dirname(path);
  }

  Future<String> _deviceModel() async {
    var model = '';
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Util.isAndroid) {
        model = (await deviceInfo.androidInfo).model;
      } else if (Util.isIOS) {
        model = (await deviceInfo.iosInfo).modelName;
      }
    } catch (_) {
      return '';
    }
    return model.replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1F]'), '_').trim();
  }

  Future<void> _handleToggleDeviceModel(bool enabled) async {
    var path = _targetPath;
    if (path.isNotEmpty) {
      path = enabled
          ? await _appendDeviceModel(path)
          : await _removeDeviceModel(path);
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
    final layout = await showCustomListOptions<AlbumDestinationLayout>(
      context: context,
      options: [
        CustomOption(
          label: '按年月日整理'.tr(),
          value: AlbumDestinationLayout.yearMonthDay,
        ),
        CustomOption(
          label: '按年月整理'.tr(),
          value: AlbumDestinationLayout.yearMonth,
        ),
        CustomOption(
          label: '文件名加资产 ID'.tr(),
          value: AlbumDestinationLayout.filenameAssetId,
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
      _form.sourceConfig = jsonEncode({
        'album_ids': [for (final source in sources) source.albumId],
      });
      final profile = _isEditing
          ? await SyncingService.instance.updateProfile(_form)
          : await SyncingService.instance.createProfile(_form);
      _form = profile;
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

  Future<void> _handleDelete() async {
    final confirmed = await showCustomConfirmDialog(
      context: context,
      title: Text('确认删除相册备份?'.tr()),
    );
    if (confirmed != true) return;
    await SyncingService.instance.deleteProfile(_form.id);
    ref.invalidate(syncProfilesProvider);
    if (mounted) Navigator.pop(context, false);
  }

  List<_AlbumSource> _albumSources() {
    return [
      for (final id in (_json(_form.sourceConfig)['album_ids'] as List?)
              ?.whereType<String>() ??
          <String>[])
        _AlbumSource(id, _albumNames[id] ?? id),
    ];
  }

  Map<String, dynamic> _json(String value) {
    final decoded = jsonDecode(value);
    return decoded is Map<String, dynamic> ? decoded : const {};
  }
}

class _AlbumSource {
  const _AlbumSource(this.albumId, this.name);

  final String albumId;
  final String name;
}
