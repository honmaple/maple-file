import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/api/syncing/widgets/album/detail.dart';
import 'package:maple_file/api/syncing/widgets/local_directory/detail.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class SyncingDetailScreen extends StatefulWidget {
  const SyncingDetailScreen({
    super.key,
    required this.profile,
  });

  final SyncProfile profile;

  factory SyncingDetailScreen.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;
    return SyncingDetailScreen(profile: args as SyncProfile);
  }

  @override
  State<SyncingDetailScreen> createState() => _SyncingDetailScreenState();
}

class _SyncingDetailScreenState extends State<SyncingDetailScreen> {
  late SyncProfile _profile;

  @override
  void initState() {
    super.initState();

    _profile = widget.profile.clone();
  }

  @override
  Widget build(BuildContext context) {
    final sourceType = SyncSourceType.fromValue(_profile.sourceType);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(_profile.name),
        trailingActions: [
          TextButton(onPressed: _handleEdit, child: Text('编辑'.tr())),
        ],
      ),
      body: switch (sourceType) {
        SyncSourceType.album => AlbumBackupDetail(
            key: ValueKey(_profile),
            profile: _profile,
            onProfileChanged: _handleProfileChanged,
          ),
        SyncSourceType.localDirectory => LocalDirectorySyncDetail(
            key: ValueKey(_profile),
            profile: _profile,
            onProfileChanged: _handleProfileChanged,
          ),
        SyncSourceType.unknown => Center(child: Text('同步详情参数无效'.tr())),
      },
    );
  }

  Future<void> _handleEdit() async {
    if (SyncSourceType.fromValue(_profile.sourceType) ==
        SyncSourceType.unknown) {
      return;
    }
    final result = await Navigator.of(context).pushNamed(
      '/syncing/edit',
      arguments: _profile,
    );
    if (!mounted) return;
    if (result == false) {
      Navigator.pop(context);
    } else if (result is SyncProfile) {
      setState(() => _profile = result);
    }
  }

  void _handleProfileChanged(SyncProfile profile) {
    _profile = profile;
  }
}
