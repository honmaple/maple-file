import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';

Future<List<AssetPathEntity>?> showAlbumSelect(
  BuildContext context, {
  required Set<String> selectedIds,
}) async {
  if (!Util.isAndroid && !Util.isIOS) {
    SmartDialog.showNotify(
      msg: '相册备份仅支持移动端'.tr(),
      notifyType: NotifyType.warning,
    );
    return null;
  }
  try {
    final albums = await AlbumBackupService.instance.requestAlbums();
    if (!context.mounted) return null;
    return Navigator.of(context).push<List<AssetPathEntity>>(
      platformPageRoute(
        context: context,
        builder: (context) => AlbumSelectScreen(
          albums: albums,
          selectedIds: selectedIds,
        ),
      ),
    );
  } catch (error) {
    SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    return null;
  }
}

class AlbumSelectScreen extends StatefulWidget {
  const AlbumSelectScreen({
    super.key,
    required this.albums,
    required this.selectedIds,
  });

  final List<AssetPathEntity> albums;
  final Set<String> selectedIds;

  @override
  State<AlbumSelectScreen> createState() => _AlbumSelectScreenState();
}

class _AlbumSelectScreenState extends State<AlbumSelectScreen> {
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
      appBar: PlatformAppBar(
        title: Text('备份相册范围'.tr()),
        trailingActions: [
          ValueListenableBuilder<int>(
            valueListenable: _selectedCount,
            builder: (context, selectedCount, _) => TextButton(
              onPressed: _handleToggleSelectAll,
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
                return _AlbumTile(
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

  void _handleToggleSelectAll() {
    if (_selected.length == widget.albums.length) {
      _selected.clear();
    } else {
      _selected.addAll(widget.albums.map((album) => album.id));
    }
    _selectedCount.value = _selected.length;
    _selectionRevision.value++;
  }
}

class _AlbumTile extends StatefulWidget {
  const _AlbumTile({
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
  State<_AlbumTile> createState() => _AlbumTileState();
}

class _AlbumTileState extends State<_AlbumTile> {
  late final ValueNotifier<bool> _selected = ValueNotifier(widget.selected);

  @override
  void initState() {
    super.initState();
    widget.selectionRevision.addListener(_handleSyncSelected);
  }

  @override
  void dispose() {
    widget.selectionRevision.removeListener(_handleSyncSelected);
    _selected.dispose();
    super.dispose();
  }

  void _handleSyncSelected() {
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
