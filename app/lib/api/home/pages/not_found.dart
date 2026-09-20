import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text("404", style: TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: Text("未找到页面".tr()),
      ),
    );
  }
}
