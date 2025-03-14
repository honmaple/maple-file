import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/api/setting/providers/info.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/responsive.dart';

class About extends ConsumerWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于".tr()),
        automaticallyImplyLeading: Breakpoint.isSmall(context),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: CustomAsyncValue(
          value: ref.watch(infoProvider),
          builder: (resp) {
            return ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset("assets/icon/icon.png", width: 80),
                      Text("红枫云盘 {version}".tr(
                        args: {"version": resp.version},
                      )),
                      const SizedBox(height: 4),
                      Text(
                        "无服务端的多协议云盘文件上传和管理".tr(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16)
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("OS".tr()),
                        trailing: Text(resp.os),
                      ),
                      ListTile(
                        title: Text("Arch".tr()),
                        trailing: Text(resp.os),
                      ),
                      ListTile(
                        title: Text("Runtime".tr()),
                        trailing: Text(resp.runtime),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("开源代码".tr()),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await launchUrl(Uri.parse(
                            "https://github.com/honmaple/maple-file",
                          ));
                        },
                      ),
                      ListTile(
                        title: Text("开源协议".tr()),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await launchUrl(Uri.parse(
                            "https://github.com/honmaple/maple-file/blob/master/LICENSE",
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
