import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/responsive.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("帮助".tr()),
        automaticallyImplyLeading: Breakpoint.isSmall(context),
      ),
      body: Center(
        child: Text("帮助".tr()),
      ),
    );
  }
}
