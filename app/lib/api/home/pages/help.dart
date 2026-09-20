import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/common/widgets/responsive.dart';
import 'package:maple_file/common/widgets/tree.dart';

class HelpLink {
  final String name;
  final String link;

  const HelpLink({required this.name, required this.link});
}

class HelpWebViewArgs {
  final String title;
  final String link;

  const HelpWebViewArgs({
    required this.title,
    required this.link,
  });
}

class HelpWebViewScreen extends StatefulWidget {
  const HelpWebViewScreen({super.key, required this.title, required this.link});

  final String title;
  final String link;

  factory HelpWebViewScreen.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments as HelpWebViewArgs;
    return HelpWebViewScreen(
      title: args.title,
      link: args.link,
    );
  }

  @override
  State<HelpWebViewScreen> createState() => _HelpWebViewState();
}

class _HelpWebViewState extends State<HelpWebViewScreen> {
  late final WebViewController _controller;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _loading = true;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          },
          onWebResourceError: (_) {
            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: Breakpoint.isSmall(context),
        trailingActions: [
          IconButton(
            onPressed: () async {
              await _controller.reload();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

Future<void> openHelpLink(
  BuildContext context,
  HelpLink item,
) async {
  if (Util.isAndroid || Util.isIOS || Util.isMacOS) {
    await Navigator.of(context).pushNamed(
      '/help/webview',
      arguments: HelpWebViewArgs(
        title: item.name,
        link: item.link,
      ),
    );
    return;
  }

  final link = item.link;
  final uri = Uri.parse(link);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    App.logger.warning("open help link failed: $link, error: $e");
  }
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
    name: "访问频率限制".tr(),
    link: "https://fileapp.honmaple.com/guide/features/ratelimit.html",
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

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return PlatformScaffold(
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: Text("帮助".tr()),
        automaticallyImplyLeading: Breakpoint.isSmall(context),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            header: Container(
              alignment: Alignment.centerLeft,
              child: Text("功能列表".tr(), style: themeData.textTheme.bodySmall),
            ),
            children: [
              for (final item in features)
                PlatformListTile(
                  title: Text(item.name),
                  trailing: PlatformListTileChevron(),
                  onTap: () async {
                    await openHelpLink(context, item);
                  },
                ),
            ],
          ),
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            header: Container(
              alignment: Alignment.centerLeft,
              child: Text("存储类型".tr(), style: themeData.textTheme.bodySmall),
            ),
            children: [
              for (final item in drivers)
                PlatformListTile(
                  title: Text(item.name),
                  trailing: PlatformListTileChevron(),
                  onTap: () async {
                    await openHelpLink(context, item);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class DesktopHelpScreen extends StatefulWidget {
  const DesktopHelpScreen({
    super.key,
  });

  @override
  State<DesktopHelpScreen> createState() => _DesktopHelpState();
}

class _DesktopHelpState extends State<DesktopHelpScreen> {
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
                    await openHelpLink(context, item);
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
                    await openHelpLink(context, item);
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
      onGenerateRoute: App.router.onGenerateRouteReplace(
        context: context,
        replace: {
          "/": null,
        },
      ),
    );
  }
}
