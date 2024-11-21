import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:grpc/grpc.dart';

class CustomError extends StatelessWidget {
  final Object err;

  const CustomError({
    super.key,
    required this.err,
  });

  @override
  Widget build(BuildContext context) {
    String text = err.toString();

    if (err.runtimeType == GrpcError) {
      final e = err as GrpcError;
      text = e.message ?? e.toString();
    }
    return Center(child: Text(text));
  }
}

class CustomAsyncValue<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) builder;

  const CustomAsyncValue({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => CustomError(err: err),
    );
  }
}

class CustomSliverAsyncValue<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) builder;
  final bool fill;

  const CustomSliverAsyncValue({
    super.key,
    required this.value,
    required this.builder,
    this.fill = true,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () {
        Widget child = const Center(
          child: CircularProgressIndicator(),
        );
        return fill
            ? SliverFillRemaining(child: child)
            : SliverToBoxAdapter(child: child);
      },
      error: (err, stack) {
        Widget child = CustomError(err: err);
        return fill
            ? SliverFillRemaining(child: child)
            : SliverToBoxAdapter(child: child);
      },
    );
  }
}

class CustomRefresh extends StatelessWidget {
  final FutureOr Function()? onRefresh;
  final FutureOr Function()? onLoad;
  final ERChildBuilder? childBuilder;
  final EasyRefreshController? controller;

  const CustomRefresh({
    super.key,
    this.controller,
    this.onRefresh,
    this.onLoad,
    required this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      controller: controller,
      //  header: TaurusHeader(
      //    skyColor: Colors.deepPurple,
      //    position: IndicatorPosition.locator,
      //    safeArea: false,
      //  ),
      header: const ClassicHeader(
        // clamping: _headerProperties.clamping,
        // backgroundColor: _headerProperties.background
        //     ? Theme.of(context).colorScheme.surfaceContainerHighest
        //     : null,
        // mainAxisAlignment: _headerProperties.alignment,
        // showMessage: _headerProperties.message,
        // showText: _headerProperties.text,
        // infiniteOffset: _headerProperties.infinite ? 70 : null,
        // triggerWhenReach: _headerProperties.immediately,
        dragText: '下拉刷新',
        armedText: '刷新中...',
        readyText: '刷新中...',
        processingText: '刷新中...',
        processedText: '刷新成功',
        noMoreText: 'No more',
        failedText: 'Failed',
        messageText: 'Last updated at %T',
      ),
      // footer: ClassicFooter(
      //   dragText: '上滑加载',
      //   armedText: '加载中...',
      //   readyText: '加载中...',
      //   processingText: '加载中...',
      //   processedText: '加载成功',
      //   noMoreText: 'No more',
      //   failedText: 'Failed',
      //   messageText: 'Last updated at %T',
      //   showText: false,
      //   showMessage: false,
      // ),
      footer: TaurusFooter(
        skyColor: Theme.of(context).primaryColor,
        // position: IndicatorPosition.locator,
        // safeArea: false,
      ),
      // header: MaterialHeader(
      //   triggerOffset: 60,
      //   //  backgroundColor: Theme.of(context).primaryColor,
      //   //  backgroundColor: Colors.white,
      // ),
      // footer: BezierFooter(
      //   triggerOffset: 60,
      //   //  backgroundColor: Theme.of(context).primaryColor,
      // ),
      onLoad: onLoad,
      onRefresh: onRefresh,

      childBuilder: childBuilder,

      // refreshOnStart: true,
      refreshOnStartHeader: BuilderHeader(
        triggerOffset: 60,
        clamping: true,
        position: IndicatorPosition.above,
        processedDuration: Duration.zero,
        builder: (ctx, state) {
          if (state.mode == IndicatorMode.inactive ||
              state.mode == IndicatorMode.done) {
            return const SizedBox();
          }
          return Center(
            child: SpinKitFadingCube(),
          );
        },
      ),
    );
  }
}

class CustomScaffoldBody extends StatefulWidget {
  const CustomScaffoldBody({
    super.key,
    required this.child,
    required this.expanded,
    this.controller,
  });

  final Widget child;
  final Widget expanded;
  final AnimationController? controller;

  @override
  State createState() => _CustomScaffoldBodyState();
}

class _CustomScaffoldBodyState extends State<CustomScaffoldBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          widget.child,
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  if (_controller.value > 0)
                    GestureDetector(
                      onTap: () {
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        }
                      },
                      child: Container(
                        color: Colors.black.withOpacity(
                          0.3 * _controller.value,
                        ),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  child!,
                ],
              );
            },
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizeTransition(
                sizeFactor: _animation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: widget.expanded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
