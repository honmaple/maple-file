import 'package:flutter/material.dart';

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/tree.dart';
import 'package:maple_file/common/widgets/custom.dart';
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
            ListTile(
              title: Text("基础设置".tr()),
              dense: true,
            ),
            Card(
              child: Column(
                children: [
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
            ListTile(
              title: Text("存储设置".tr()),
              dense: true,
            ),
            Card(
              child: Column(
                children: [
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
  const DesktopSetting({
    super.key,
  });

  @override
  State<DesktopSetting> createState() => _DesktopSettingState();
}

class _DesktopSettingState extends State<DesktopSetting> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState navigatorState(context) {
    return _navigatorKey.currentState ?? Navigator.of(context);
  }

  _navigatorPush(String name) {
    navigatorState(context).pushReplacementNamed(name);
  }

  @override
  Widget build(BuildContext context) {
    final menu = [
      CustomTreeMenu(
        label: "基础设置".tr(),
        expanded: true,
        children: [
          CustomTreeMenu(
            icon: Icons.brightness_medium,
            label: "主题".tr(),
            onTap: () {
              _navigatorPush('/setting/theme');
            },
          ),
          CustomTreeMenu(
            icon: Icons.language,
            label: "语言".tr(),
            onTap: () {
              _navigatorPush('/setting/locale');
            },
          ),
          CustomTreeMenu(
            icon: Icons.backup,
            label: "备份与恢复".tr(),
            onTap: () {
              _navigatorPush('/setting/backup');
            },
          ),
        ],
      ),
      CustomTreeMenu(
        label: "存储设置".tr(),
        expanded: true,
        children: [
          CustomTreeMenu(
            icon: Icons.storage,
            label: "存储库".tr(),
            onTap: () {
              _navigatorPush('/file/setting/repo');
            },
          ),
          CustomTreeMenu(
            icon: Icons.upload,
            label: '文件上传'.tr(),
            onTap: () {
              _navigatorPush('/file/setting/upload');
            },
          ),
          CustomTreeMenu(
            icon: Icons.download,
            label: '文件下载'.tr(),
            onTap: () {
              _navigatorPush('/file/setting/download');
            },
          ),
          CustomTreeMenu(
            icon: Icons.palette,
            label: '文件展示'.tr(),
            onTap: () {
              _navigatorPush('/file/setting/theme');
            },
          ),
        ],
      ),
    ];

    return CustomLayout(
      menu: menu,
      navigatorKey: _navigatorKey,
      initialRoute: "/setting",
      onGenerateRoute: App.router.replaceRoute(replace: {
        "/": null,
      }),
    );
  }
}
