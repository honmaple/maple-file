import 'dart:math' as math;
import 'package:flutter/material.dart';

class KeyboardHeightBuilder extends StatefulWidget {
  const KeyboardHeightBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext, double, double) builder;

  @override
  State<KeyboardHeightBuilder> createState() => _KeyboardHeightBuilderState();
}

class _KeyboardHeightBuilderState extends State<KeyboardHeightBuilder>
    with WidgetsBindingObserver {
  double _height = 0;
  double _maxHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _height, _maxHeight);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      final bottom = EdgeInsets.fromViewPadding(
        View.of(context).viewInsets,
        View.of(context).devicePixelRatio,
      ).bottom;

      _maxHeight = math.max(_maxHeight, bottom);
      if (_height != bottom) {
        setState(() {
          _height = bottom;
        });
      }
    }
  }
}
