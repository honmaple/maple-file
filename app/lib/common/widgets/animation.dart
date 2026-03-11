import 'dart:math' as math show sin, pi;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef CustomAnimationWidgetBuilder<T> = Widget Function(
    BuildContext context, Animation<T> value, Widget? child);

class CustomAnimationBuilder<T, V> extends StatefulWidget {
  final V? data;
  final Curve curve;
  final Duration? duration;
  final Tween<T> tween;
  final CustomAnimationWidgetBuilder<T> builder;
  final Widget? child;

  const CustomAnimationBuilder({
    super.key,
    required this.tween,
    required this.builder,
    this.curve = Curves.linear,
    this.data,
    this.duration,
    this.child,
  });

  @override
  State<CustomAnimationBuilder> createState() =>
      _CustomAnimationBuilderState<T, V>();
}

class _CustomAnimationBuilderState<T, V>
    extends State<CustomAnimationBuilder<T, V>>
    with TickerProviderStateMixin<CustomAnimationBuilder<T, V>> {
  late final CurvedAnimation animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    _setAnimation();
  }

  @override
  void dispose() {
    animation.dispose();
    animationController?.dispose();
    super.dispose();
  }

  void _setAnimation() {
    final controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? Duration(milliseconds: 150),
    )..addListener(() => setState(() {}));
    controller.forward();

    animation = CurvedAnimation(parent: controller, curve: widget.curve);
    animationController = controller;
  }

  @override
  Widget build(context) {
    return widget.builder(
      context,
      widget.tween.animate(animation),
      widget.child,
    );
  }

  @override
  void didUpdateWidget(CustomAnimationBuilder<T, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder.runtimeType != widget.builder.runtimeType) {
      animationController?.dispose();
      _setAnimation();
    } else {
      if (widget.data == oldWidget.data) {
        return;
      }
      animationController?.reset();
      animationController?.forward();
    }
  }
}

class CustomAnimatedCollapse extends StatefulWidget {
  const CustomAnimatedCollapse({
    super.key,
    this.child,
    required this.collapsed,
    this.axis = Axis.vertical,
    this.axisAlignment = 0.0,
    this.curve = Curves.fastOutSlowIn,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
  });

  final Widget? child;

  /// Show or hide the child
  final bool collapsed;

  /// See [SizeTransition]
  final Axis axis;

  /// See [SizeTransition]
  final double axisAlignment;
  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;

  @override
  State<CustomAnimatedCollapse> createState() => _CustomAnimatedCollapseState();
}

class _CustomAnimatedCollapseState extends State<CustomAnimatedCollapse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.collapsed ? 0.0 : 1.0,
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void didUpdateWidget(covariant CustomAnimatedCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.collapsed != oldWidget.collapsed) {
      if (widget.collapsed) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SizeTransition(
        sizeFactor: _animation,
        axis: widget.axis,
        axisAlignment: widget.axisAlignment,
        child: widget.child,
      ),
    );
  }
}

class DelayTween extends Tween<double> {
  DelayTween({
    super.begin,
    super.end,
    required this.delay,
  });

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class CustomWaveAnimation extends StatefulWidget {
  const CustomWaveAnimation({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemCount = 5,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : assert(itemCount >= 2, 'itemCount Cant be less then 2 ');

  final Color? color;
  final int itemCount;
  final double size;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<CustomWaveAnimation> createState() => _CustomWaveAnimationState();
}

class _CustomWaveAnimationState extends State<CustomWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.itemCount, (i) {
        return ScaleYWidget(
          scaleY: DelayTween(
            begin: .4,
            end: 1.0,
            delay: -1.0 + (i * 0.2) + 0.2,
          ).animate(_controller),
          child: Container(
            width: 4,
            margin: EdgeInsets.symmetric(horizontal: 2),
            height: widget.size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
