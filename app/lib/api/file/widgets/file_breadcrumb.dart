import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/breadcrumb.dart';

class FileBreadcrumb extends StatelessWidget {
  final String path;

  const FileBreadcrumb({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    List<String> list = path.split('/');
    return Breadcrumb(
      children: [
        for (int index = 0; index < list.length; index++)
          index == 0
              ? BreadcrumbItem(
                  child: Text("全部文件".tr()),
                  onTap: () {
                    int length = list.length - index;
                    Navigator.popUntil(context, (route) {
                      length--;
                      return length <= 0;
                    });
                  },
                )
              : BreadcrumbItem(
                  onTap: () {
                    int length = list.length - index;
                    Navigator.popUntil(context, (route) {
                      length--;
                      return length <= 0;
                    });
                  },
                  child: Text(list[index]),
                ),
      ],
    );
  }
}
