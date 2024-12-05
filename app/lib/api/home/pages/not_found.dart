import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("404", style: TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: Text("未找到页面".tr(context)),
      ),
    );
  }
}
