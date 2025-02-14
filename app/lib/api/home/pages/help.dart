import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/responsive.dart';
import 'package:maple_file/common/widgets/tree.dart';

class HelpLink {
  final String name;
  final String link;

  const HelpLink({required this.name, required this.link});
}

List<HelpLink> features = [
  HelpLink(
    name: "文件预览".tr(),
    link: "https://fileapp.honmaple.com/guide/features/preview.html",
  ),
  HelpLink(
    name: "文件操作".tr(),
    link: "https://fileapp.honmaple.com/guide/features/action.html",
  ),
  HelpLink(
    name: "文件缓存".tr(),
    link: "https://fileapp.honmaple.com/guide/features/cache.html",
  ),
  HelpLink(
    name: "文件压缩".tr(),
    link: "https://fileapp.honmaple.com/guide/features/compress.html",
  ),
  HelpLink(
    name: "文件加密".tr(),
    link: "https://fileapp.honmaple.com/guide/features/encrypt.html",
  ),
  HelpLink(
    name: "回收站".tr(),
    link: "https://fileapp.honmaple.com/guide/features/recycle.html",
  ),
  HelpLink(
    name: "常见问题".tr(),
    link: "https://fileapp.honmaple.com/guide/faq.html",
  ),
];

List<HelpLink> drivers = [
  HelpLink(
    name: "公共参数".tr(),
    link: "https://fileapp.honmaple.com/guide/drivers/common.html",
  ),
  const HelpLink(
    name: "S3",
    link: "https://fileapp.honmaple.com/guide/drivers/s3.html",
  ),
  const HelpLink(
    name: "SMB",
    link: "https://fileapp.honmaple.com/guide/drivers/smb.html",
  ),
  const HelpLink(
    name: "FTP",
    link: "https://fileapp.honmaple.com/guide/drivers/ftp.html",
  ),
  const HelpLink(
    name: "SFTP",
    link: "https://fileapp.honmaple.com/guide/drivers/sftp.html",
  ),
  const HelpLink(
    name: "Alist",
    link: "https://fileapp.honmaple.com/guide/drivers/alist.html",
  ),
  const HelpLink(
    name: "Mirror",
    link: "https://fileapp.honmaple.com/guide/drivers/mirror.html",
  ),
  const HelpLink(
    name: "Webdav",
    link: "https://fileapp.honmaple.com/guide/drivers/webdav.html",
  ),
  HelpLink(
    name: "又拍云".tr(),
    link: "https://fileapp.honmaple.com/guide/drivers/upyun.html",
  ),
];

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("帮助".tr()),
        automaticallyImplyLeading: Breakpoint.isSmall(context),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: [
            ListTile(
              dense: true,
              title: Text("功能列表".tr()),
            ),
            Card(
              child: Column(
                children: [
                  for (final item in features)
                    ListTile(
                      title: Text(item.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(
                            item.link,
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                ],
              ),
            ),
            ListTile(
              dense: true,
              title: Text("存储类型".tr()),
            ),
            Card(
              child: Column(
                children: [
                  for (final item in drivers)
                    ListTile(
                      title: Text(item.name),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(
                            item.link,
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopHelp extends StatefulWidget {
  const DesktopHelp({
    super.key,
  });

  @override
  State<DesktopHelp> createState() => _DesktopHelpState();
}

class _DesktopHelpState extends State<DesktopHelp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  _navigatorPush(String name) {
    final state = _navigatorKey.currentState ?? Navigator.of(context);
    state.pushReplacementNamed(name);
  }

  @override
  Widget build(BuildContext context) {
    final menu = [
      CustomTreeMenu(
        icon: Icons.help,
        label: "帮助".tr(),
        expanded: true,
        children: [
          CustomTreeMenu(
            icon: Icons.link,
            label: "功能列表".tr(),
            expanded: true,
            children: [
              for (final item in features)
                CustomTreeMenu(
                  label: item.name,
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(item.link),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
            ],
          ),
          CustomTreeMenu(
            icon: Icons.link,
            label: "存储类型".tr(),
            children: [
              for (final item in drivers)
                CustomTreeMenu(
                  label: item.name,
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(item.link),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
      CustomTreeMenu(
        icon: Icons.person,
        label: "关于".tr(),
        onTap: () {
          _navigatorPush('/about');
        },
      ),
    ];
    return CustomLayout(
      menu: menu,
      navigatorKey: _navigatorKey,
      initialRoute: "/about",
      onGenerateRoute: App.router.replaceRoute(replace: {
        "/": null,
      }),
    );
  }
}
