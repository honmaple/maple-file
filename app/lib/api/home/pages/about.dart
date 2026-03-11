import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/common/widgets/responsive.dart';

import 'package:maple_file/api/setting/providers/info.dart';

class About extends ConsumerWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text("关于".tr()),
        automaticallyImplyLeading: Breakpoint.isSmall(context),
      ),
      body: CustomAsyncValue(
        value: ref.watch(infoProvider),
        builder: (resp) {
          return Column(
            children: [
              CustomListSection(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset("assets/icon/icon.png", width: 80),
                        Text("红枫云盘 {version}".tr(
                          args: {"version": resp.version},
                        )),
                        const SizedBox(height: 8),
                        Text(
                          "无服务端的多协议云盘文件上传和管理".tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16)
                      ],
                    ),
                  )
                ],
              ),
              CustomListSection(
                hasLeading: false,
                dividerMargin: 20,
                children: [
                  PlatformListTile(
                    title: Text("OS".tr()),
                    trailing: Text(resp.os),
                  ),
                  PlatformListTile(
                    title: Text("Arch".tr()),
                    trailing: Text(resp.os),
                  ),
                ],
              ),
              CustomListSection(
                hasLeading: false,
                dividerMargin: 20,
                children: [
                  PlatformListTile(
                    title: Text("开源代码".tr()),
                    trailing: PlatformListTileChevron(),
                    onTap: () async {
                      await launchUrl(Uri.parse(
                        "https://github.com/honmaple/maple-file",
                      ));
                    },
                  ),
                  PlatformListTile(
                    title: Text("开源协议".tr()),
                    trailing: PlatformListTileChevron(),
                    onTap: () async {
                      await launchUrl(Uri.parse(
                        "https://github.com/honmaple/maple-file/blob/master/LICENSE",
                      ));
                    },
                  ),
                ],
              ),
              CustomListSection(
                hasLeading: false,
                dividerMargin: 20,
                children: [
                  PlatformListTile(
                    title: Text("联系我".tr()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("mail@honmaple.com"),
                        PlatformListTileChevron(),
                      ],
                    ),
                    onTap: () {
                      String? encodeQueryParameters(
                          Map<String, String> params) {
                        return params.entries
                            .map((MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      final uri = Uri(
                        scheme: "mailto",
                        path: "mail@honmaple.com",
                        query: encodeQueryParameters(<String, String>{
                          "subject": 'Hello, honmaple',
                        }),
                      );
                      launchUrl(uri);
                    },
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(bottom: 32),
                child: Column(children: [
                  Text(
                    '© ${now.year} honmaple',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
