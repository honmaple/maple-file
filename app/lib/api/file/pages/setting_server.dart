import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/platform.dart';

import 'package:maple_file/api/file/widgets/server/webdav.dart';

class FileSettingServerScreen extends ConsumerStatefulWidget {
  const FileSettingServerScreen({super.key});

  @override
  ConsumerState<FileSettingServerScreen> createState() =>
      _FileSettingServerState();
}

class _FileSettingServerState extends ConsumerState<FileSettingServerScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('外部服务'.tr()),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            children: [
              PlatformListTile(
                leading: Icon(
                  Icons.storage,
                  color: themeData.colorScheme.primary,
                ),
                title: Text("Webdav".tr()),
                trailing: PlatformListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(platformPageRoute(
                      context: context,
                      builder: (context) {
                        return WebdavServer();
                      }));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
