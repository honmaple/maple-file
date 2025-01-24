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
                      Image.asset("assets/icon/icon-transparent.png",
                          width: 80),
                      Text("红枫云盘 {version}".tr(
                        args: {"version": resp.version},
                      )),
                      if (resp.description != "") Text(resp.description),
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
                        title: Text("Github".tr()),
                        trailing: const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text("honmaple/maple-file"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () async {
                          await launchUrl(Uri.parse(
                            "https://github.com/honmaple/maple-file",
                          ));
                        },
                      ),
                      ListTile(
                        title: Text("License".tr()),
                        trailing: const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text("GPL-3.0"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
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
