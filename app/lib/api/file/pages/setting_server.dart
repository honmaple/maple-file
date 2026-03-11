import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/platform.dart';

import 'package:maple_file/api/file/widgets/server/webdav.dart';

class FileSettingServer extends ConsumerStatefulWidget {
  const FileSettingServer({super.key});

  @override
  ConsumerState<FileSettingServer> createState() => _FileSettingServerState();
}

class _FileSettingServerState extends ConsumerState<FileSettingServer> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
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
