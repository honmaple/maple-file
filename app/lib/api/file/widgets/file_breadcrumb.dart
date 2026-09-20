import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/breadcrumb.dart';

class FileBreadcrumb extends StatelessWidget {
  final String path;
  final ValueChanged<String> onChanged;

  const FileBreadcrumb({
    super.key,
    required this.path,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final parts = path.split('/');
    final colorScheme = Theme.of(context).colorScheme;
    return Breadcrumb(
      divider: Icon(
        Icons.chevron_right,
        size: 18,
        color: colorScheme.outline.withValues(alpha: .55),
      ),
      children: [
        for (int index = 0; index < parts.length; index++)
          _buildItem(context, parts, index),
      ],
    );
  }

  Widget _buildItem(BuildContext context, List<String> parts, int index) {
    final theme = Theme.of(context);
    final isCurrent = index == parts.length - 1;
    return BreadcrumbItem(
      onTap: isCurrent ? null : () => _handleTap(parts, index),
      child: Text(
        index == 0 ? '全部文件'.tr() : parts[index],
        style: theme.textTheme.bodySmall?.copyWith(
          color: isCurrent
              ? theme.colorScheme.onSurface
              : theme.colorScheme.primary,
        ),
      ),
    );
  }

  void _handleTap(List<String> parts, int index) {
    final path = index == 0 ? '/' : '/${parts.sublist(1, index + 1).join('/')}';
    onChanged(path);
  }
}
