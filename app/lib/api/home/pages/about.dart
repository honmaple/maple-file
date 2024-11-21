import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于".tr(context), style: const TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: Text("关于".tr(context)),
      ),
    );
  }
}
