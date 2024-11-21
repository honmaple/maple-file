import 'package:flutter/material.dart';

// https://github.com/flutter/flutter/issues/29749
class ExpandablePageView extends StatefulWidget {
  final List<Widget> children;
  final PageController? controller;
  final Function(int)? onPageChange;

  const ExpandablePageView({
    super.key,
    this.controller,
    this.onPageChange,
    required this.children,
  });

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView>
    with TickerProviderStateMixin {
  late final _reportedChildrenHeights =
      List.filled(widget.children.length, 0.0);

  int _currentPage = 0;

  double get _currentHeight => _reportedChildrenHeights[_currentPage];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(
          begin: _reportedChildrenHeights[0], end: _currentHeight),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: PageView(
        controller: widget.controller,
        children: _sizeReportingChildren,
        onPageChanged: (index) {
          widget.onPageChange?.call(index);
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }

  List<Widget> get _sizeReportingChildren =>
      widget.children.indexed.map((entry) {
        final (index, child) = entry;

        return OverflowBox(
          //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
          minHeight: 0,
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: SizeReportingWidget(
            onSizeChange: (size) =>
                setState(() => _reportedChildrenHeights[index] = size.height),
            child: child,
          ),
        );
      }).toList();
}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget(
      {required this.child, required this.onSizeChange, super.key});

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      if (size != null) {
        widget.onSizeChange(size);
      }
    }
  }
}
