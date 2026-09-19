import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/api/file/widgets/directory_select.dart';
import 'package:maple_file/api/syncing/pages/album_backup_history.dart';
import 'package:maple_file/api/syncing/providers/album_backup_run.dart';
import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/utils/time.dart';
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
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _form = widget.profile == null
        ? SyncProfile(
            name: '相册备份'.tr(),
            enabled: true,
            mode: SyncProfile_Mode.MODE_BACKUP,
            sourceType: 'album',
            sourceConfig: jsonEncode({'album_ids': <String>[]}),
            targetType: 'repo_directory',
            targetConfig: jsonEncode({'path': '', 'layout': 'year_month_day'}),
            policyConfig: '{}',
          )
        : (SyncProfile()..mergeFromMessage(widget.profile!));
    if (Util.isAndroid || Util.isIOS) {
      _loadAlbumNames();
    }
  }

  Future<void> _loadAlbumNames() async {
    try {
      final albums =
          await SyncingService.instance.requestAlbums(includeEmpty: true);
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
              if (_isEditing)
                ref.watch(albumBackupRunsProvider(_form.id)).when(
                      loading: () => ListTile(title: Text('读取备份记录'.tr())),
                      error: (error, _) => ListTile(
                        title: Text('备份记录加载失败'.tr()),
                        subtitle: Text('$error'),
                        onTap: () =>
                            ref.invalidate(albumBackupRunsProvider(_form.id)),
                      ),
                      data: (runs) {
                        final latest = runs.firstOrNull;
                        return PlatformListTile(
                          leading: Icon(
                            latest == null
                                ? Icons.cloud_upload_outlined
                                : latest.isRunning
                                    ? Icons.sync
                                    : latest.hasFailed
                                        ? Icons.error_outline
                                        : Icons.check_circle_outline,
                            color: latest == null
                                ? null
                                : latest.hasFailed
                                    ? Theme.of(context).colorScheme.error
                                    : Colors.green,
                          ),
                          title: Text(
                            latest == null
                                ? '尚未备份'.tr()
                                : latest.isRunning
                                    ? '备份中'.tr()
                                    : latest.isInterrupted
                                        ? '备份已中断'.tr()
                                        : latest.hasFailed
                                            ? '备份失败'.tr()
                                            : '已备份至最新'.tr(),
                          ),
                          subtitle: latest == null
                              ? null
                              : Text(
                                  '上次备份时间：{time}'.tr(args: {
                                    'time': TimeUtil.datetimeToString(
                                      latest.finishedAt,
                                    ),
                                  }),
                                ),
                          trailing: const PlatformListTileChevron(),
                          onTap: () => Navigator.of(context).push(
                            platformPageRoute(
                              context: context,
                              builder: (context) => AlbumBackupHistoryScreen(
                                profileId: _form.id,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
          CustomListSection(
            header: Text('备份源'.tr()),
            children: [
              PlatformListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('备份相册'.tr()),
                subtitle: Text(
                  sources.isEmpty
                      ? '未选择'.tr()
                      : sources.map((source) => source.name).join('、'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: () => _selectAlbums(sources),
              ),
            ],
          ),
          CustomListSection(
            header: Text('备份到'.tr()),
            children: [
              PlatformListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text('云端目录'.tr()),
                subtitle: Text(
                  _targetPath.isEmpty ? '未选择'.tr() : _targetPath,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: _selectTarget,
              ),
            ],
          ),
          CustomListSection(
            header: Text('其它设置'.tr()),
            children: [
              PlatformListTile(
                leading: const Icon(Icons.account_tree_outlined),
                title: Text('目的地整理'.tr()),
                subtitle: Text(
                  _layout == 'year_month_day'
                      ? '按年月日整理'.tr()
                      : '文件名加资产 ID'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const PlatformListTileChevron(),
                onTap: _selectLayout,
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
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: OutlinedButton.icon(
                onPressed: _form.enabled && !_running
                    ? () => _handleRun(sources)
                    : null,
                icon: const Icon(Icons.sync),
                label: Text(_running ? '备份中'.tr() : '立即备份'.tr()),
              ),
            ),
        ],
      ),
    );
  }

  String get _targetPath => _json(_form.targetConfig)['path'] as String? ?? '';

  String get _layout =>
      _json(_form.targetConfig)['layout'] as String? ?? 'year_month_day';

  void _updateTargetConfig({String? path, String? layout}) {
    _form.targetConfig = jsonEncode({
      'path': path ?? _targetPath,
      'layout': layout ?? _layout,
    });
  }

  Future<void> _selectTarget() async {
    final selectedPath = await showCustomDialog<String>(
      context,
      width: 560,
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: FileDirectorySelect(title: '选择备份目录'.tr()),
    );
    if (selectedPath != null && mounted) {
      final path =
          _isEditing ? selectedPath : await _appendDeviceModel(selectedPath);
      if (!mounted) return;
      setState(() => _updateTargetConfig(path: path));
    }
  }

  Future<String> _appendDeviceModel(String path) async {
    final deviceInfo = DeviceInfoPlugin();
    var model = '';
    if (Util.isAndroid) {
      model = (await deviceInfo.androidInfo).model;
    } else if (Util.isIOS) {
      model = (await deviceInfo.iosInfo).modelName;
    }
    model = model.replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1F]'), '_').trim();
    if (model.isEmpty || filepath.posix.basename(path) == model) return path;
    return filepath.posix.join(path, model);
  }

  Future<void> _selectAlbums(List<_AlbumSource> sources) async {
    if (!Util.isAndroid && !Util.isIOS) {
      SmartDialog.showNotify(
        msg: '相册备份仅支持移动端'.tr(),
        notifyType: NotifyType.warning,
      );
      return;
    }
    try {
      final albums = await SyncingService.instance.requestAlbums();
      if (!mounted) return;
      _albumNames = {for (final album in albums) album.id: album.name};
      final selected = await Navigator.of(context).push<List<AssetPathEntity>>(
        platformPageRoute(
          context: context,
          builder: (context) => AlbumBackupSourceScreen(
            albums: albums,
            selectedIds: sources.map((source) => source.albumId).toSet(),
          ),
        ),
      );
      if (selected == null || !mounted) return;
      setState(() {
        _selectedSources = [
          for (final album in selected) _AlbumSource(album.id, album.name),
        ];
      });
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  Future<void> _selectLayout() async {
    final layout = await showCustomListOptions<String>(
      context: context,
      options: [
        CustomOption(
          label: '按年月日整理'.tr(),
          value: 'year_month_day',
        ),
        CustomOption(
          label: '文件名加资产 ID'.tr(),
          value: 'filename_asset_id',
        ),
      ],
    );
    if (layout != null && mounted) {
      setState(() => _updateTargetConfig(layout: layout));
    }
  }

  Future<SyncProfile?> _save(List<_AlbumSource> sources) async {
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
    final profile = await _save(sources);
    if (profile != null && mounted) Navigator.pop(context);
  }

  Future<void> _handleRun(List<_AlbumSource> sources) async {
    if (_running) return;
    setState(() => _running = true);
    try {
      final profile = await _save(sources);
      if (profile == null) return;
      final startedAt = DateTime.now();
      final runId = await AlbumBackupRunStore.start(profile.id, startedAt);
      AlbumBackupResult? result;
      String? errorMessage;
      try {
        result = await SyncingService.instance.runAlbumBackup(profile);
      } catch (error) {
        errorMessage = '$error';
      }
      final run = AlbumBackupRun(
        startedAt: startedAt,
        finishedAt: DateTime.now(),
        uploaded: result?.uploaded ?? 0,
        skipped: result?.skipped ?? 0,
        scanned: result?.scanned ?? 0,
        failures: result?.failures ?? const [],
        error: errorMessage,
      );
      try {
        await AlbumBackupRunStore.finish(profile.id, runId, run);
        ref.invalidate(albumBackupRunsProvider(profile.id));
      } catch (error) {
        SmartDialog.showNotify(
          msg: '保存备份记录失败：$error',
          notifyType: NotifyType.error,
        );
      }
      if (!mounted) return;
      if (run.hasFailed) {
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => AlbumBackupRunDetailScreen(run: run),
          ),
        );
      } else {
        SmartDialog.showNotify(
          msg: '备份完成：上传{uploaded}，跳过{skipped}，失败{failed}'.tr(args: {
            'uploaded': run.uploaded,
            'skipped': run.skipped,
            'failed': run.failed,
          }),
          notifyType: NotifyType.success,
        );
      }
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showCustomConfirmDialog(
      context: context,
      title: Text('确认删除相册备份?'.tr()),
    );
    if (confirmed != true) return;
    await SyncingService.instance.deleteProfile(_form.id);
    ref.invalidate(syncProfilesProvider);
    if (mounted) Navigator.pop(context);
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

class AlbumBackupSourceScreen extends StatefulWidget {
  const AlbumBackupSourceScreen({
    super.key,
    required this.albums,
    required this.selectedIds,
  });

  final List<AssetPathEntity> albums;
  final Set<String> selectedIds;

  @override
  State<AlbumBackupSourceScreen> createState() => _AlbumBackupSourceState();
}

class _AlbumBackupSourceState extends State<AlbumBackupSourceScreen> {
  late final Set<String> _selected = {...widget.selectedIds};
  late final ValueNotifier<int> _selectedCount =
      ValueNotifier<int>(_selected.length);
  final ValueNotifier<int> _selectionRevision = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedCount.dispose();
    _selectionRevision.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text('备份相册范围'.tr()),
        trailingActions: [
          ValueListenableBuilder<int>(
            valueListenable: _selectedCount,
            builder: (context, selectedCount, _) => TextButton(
              onPressed: _toggleSelectAll,
              child: Text(
                selectedCount == widget.albums.length ? '取消全选'.tr() : '全选'.tr(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: .72,
              ),
              itemCount: widget.albums.length,
              itemBuilder: (context, index) {
                final album = widget.albums[index];
                return _AlbumSourceTile(
                  album: album,
                  selected: _selected.contains(album.id),
                  selectionRevision: _selectionRevision,
                  isSelected: () => _selected.contains(album.id),
                  onSelectedChanged: (selected) {
                    if (selected) {
                      _selected.add(album.id);
                    } else {
                      _selected.remove(album.id);
                    }
                    _selectedCount.value = _selected.length;
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedCount,
                builder: (context, selectedCount, _) => FilledButton(
                  onPressed: selectedCount == 0
                      ? null
                      : () => Navigator.pop(
                            context,
                            widget.albums
                                .where((album) => _selected.contains(album.id))
                                .toList(),
                          ),
                  child: Text('确认'.tr()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSelectAll() {
    if (_selected.length == widget.albums.length) {
      _selected.clear();
    } else {
      _selected.addAll(widget.albums.map((album) => album.id));
    }
    _selectedCount.value = _selected.length;
    _selectionRevision.value++;
  }
}

class _AlbumSourceTile extends StatefulWidget {
  const _AlbumSourceTile({
    required this.album,
    required this.selected,
    required this.selectionRevision,
    required this.isSelected,
    required this.onSelectedChanged,
  });

  final AssetPathEntity album;
  final bool selected;
  final ValueListenable<int> selectionRevision;
  final bool Function() isSelected;
  final ValueChanged<bool> onSelectedChanged;

  @override
  State<_AlbumSourceTile> createState() => _AlbumSourceTileState();
}

class _AlbumSourceTileState extends State<_AlbumSourceTile> {
  late final ValueNotifier<bool> _selected = ValueNotifier(widget.selected);

  @override
  void initState() {
    super.initState();
    widget.selectionRevision.addListener(_syncSelected);
  }

  @override
  void dispose() {
    widget.selectionRevision.removeListener(_syncSelected);
    _selected.dispose();
    super.dispose();
  }

  void _syncSelected() {
    _selected.value = widget.isSelected();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selected.value = !_selected.value;
        widget.onSelectedChanged(_selected.value);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _AlbumCover(album: widget.album),
                Positioned(
                  top: 8,
                  right: 8,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _selected,
                    builder: (context, selected, _) => Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.album.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          FutureBuilder<int>(
            future: widget.album.assetCountAsync,
            builder: (context, snapshot) => Text(
              '${snapshot.data ?? 0} ${'项'.tr()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumCover extends StatelessWidget {
  const _AlbumCover({required this.album});

  final AssetPathEntity album;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FutureBuilder<List<AssetEntity>>(
        future: album.getAssetListPaged(page: 0, size: 1),
        builder: (context, snapshot) {
          final asset = snapshot.data?.firstOrNull;
          if (asset == null) {
            return ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: Icon(Icons.photo_library_outlined)),
            );
          }
          return FutureBuilder<Uint8List?>(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(360, 360)),
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              return Image.memory(data, fit: BoxFit.cover);
            },
          );
        },
      ),
    );
  }
}
