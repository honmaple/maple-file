import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/api/setting/providers/info.dart';
import 'package:maple_file/common/widgets/custom.dart';

class About extends ConsumerWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于".tr(context), style: const TextStyle(fontSize: 16)),
      ),
      body: CustomAsyncValue(
        value: ref.watch(infoProvider),
        builder: (resp) {
          return ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/icon/icon-transparent.png", width: 80),
                    Text("红枫云盘 {version}".tr(
                      context,
                      args: {"version": resp.version},
                    )),
                    Text(resp.description),
                  ],
                ),
              ),
              ListTile(
                title: Text("OS".tr(context)),
                trailing: Text(resp.os),
              ),
              ListTile(
                title: Text("Arch".tr(context)),
                trailing: Text(resp.os),
              ),
              ListTile(
                title: Text("Runtime".tr(context)),
                trailing: Text(resp.runtime),
              ),
            ],
          );
        },
      ),
    );
  }
}
