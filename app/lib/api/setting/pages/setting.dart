import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/responsive.dart';

class Setting extends StatelessWidget {
  const Setting({super.key, this.navigatorKey});

  final GlobalKey<NavigatorState>? navigatorKey;

  // 必须使用function才能获取到currentState
  NavigatorState navigatorState(context) {
    return navigatorKey?.currentState ?? Navigator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("设置".tr()),
        centerTitle: true,
        automaticallyImplyLeading: Breakpoint.isSmall(context),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("基础设置".tr()),
                    dense: true,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.brightness_medium,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text("主题".tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/setting/theme');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text("语言".tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/setting/locale');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.backup,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text("备份与恢复".tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/setting/backup');
                    },
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(context.tr("存储设置")),
                    dense: true,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.storage,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text("存储库".tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/file/setting/repo');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.sync,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text('同步备份'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/file/setting/task');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.upload,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text('文件上传'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/file/setting/upload');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.download,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text('文件下载'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context)
                          .pushNamed('/file/setting/download');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.palette,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text('文件展示'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/file/setting/theme');
                    },
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.help,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text("帮助".tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/help');
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: themeData.colorScheme.primary,
                    ),
                    title: Text("关于".tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      navigatorState(context).pushNamed('/about');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DesktopSetting extends StatefulWidget {
  final Widget? child;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;

  const DesktopSetting({
    super.key,
    this.child,
    this.initialRoute,
    this.onGenerateRoute,
  });

  @override
  State<DesktopSetting> createState() => _DesktopSettingState();
}

class _DesktopSettingState extends State<DesktopSetting> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
      },
      child: Scaffold(
        body: Row(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Setting(navigatorKey: _navigatorKey),
            ),
            const VerticalDivider(thickness: 1, width: 0.5),
            Expanded(
              child: widget.child ??
                  Navigator(
                    key: _navigatorKey,
                    initialRoute: widget.initialRoute,
                    onGenerateRoute: widget.onGenerateRoute,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
