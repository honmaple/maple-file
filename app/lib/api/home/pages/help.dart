import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("帮助".tr(context), style: const TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: Text("帮助".tr(context)),
      ),
    );
  }
}
