import 'package:flutter/material.dart';

class CustomTreeNode<T> {
  CustomTreeNode(
    T content, {
    String? key,
    bool expanded = false,
    List<CustomTreeNode<T>>? children,
  })  : _expanded = children != null && children.isNotEmpty && expanded,
        _key = key ?? content.toString(),
        _content = content,
        _children = children ?? <CustomTreeNode<T>>[];

  String get key => _key;
  final String _key;

  T get content => _content;
  final T _content;

  List<CustomTreeNode<T>> get children => _children;
  final List<CustomTreeNode<T>> _children;

  bool get isExpanded => _expanded;
  bool _expanded;

  int? get depth => _depth;
  int? _depth;

  CustomTreeNode<T>? get parent => _parent;
  CustomTreeNode<T>? _parent;

  @override
  String toString() {
    return 'CustomTreeNode: $content, depth: ${depth == 0 ? 'root' : depth}, '
        '${children.isEmpty ? 'leaf' : 'parent, expanded: $isExpanded'}';
  }
}

class CustomTreeViewController {
  CustomTreeViewController();

  _CustomTreeViewStateMixin<Object?, _CustomTreeView<Object?>>? _state;

  bool isExpanded(CustomTreeNode<Object?> node) {
    assert(_state != null);
    return _state!.isExpanded(node);
  }

  void toggleNode(CustomTreeNode<Object?> node) {
    assert(_state != null);
    return _state!.toggleNode(node);
  }

  void expandNode(CustomTreeNode<Object?> node) {
    assert(_state != null);
    if (!node.isExpanded) {
      _state!.toggleNode(node);
    }
  }

  void collapseNode(CustomTreeNode<Object?> node) {
    assert(_state != null);
    if (node.isExpanded) {
      _state!.toggleNode(node);
    }
  }

  static CustomTreeViewController of(BuildContext context) {
    final _CustomTreeViewState<Object?>? result =
        context.findAncestorStateOfType<_CustomTreeViewState<Object?>>();
    if (result != null) {
      return result.controller;
    }
    throw FlutterError('No _CustomTreeViewState found');
  }
}

class CustomTreeView<T> extends _CustomTreeView<T> {
  const CustomTreeView({
    super.key,
    required super.tree,
    super.controller,
    super.nodeBuilder = CustomTreeView.defaultNodeBuilder,
    super.toggleAnimationStyle,
  });

  static const Curve defaultAnimationCurve = Curves.linear;

  static Widget wrapChildToToggleNode({
    required CustomTreeNode<Object?> node,
    required Widget child,
  }) {
    return Builder(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          CustomTreeViewController.of(context).toggleNode(node);
        },
        child: child,
      );
    });
  }

  static Widget defaultNodeBuilder<T>(
    BuildContext context,
    CustomTreeNode<Object?> node,
  ) {
    return GestureDetector(
      onTap: () {
        CustomTreeViewController.of(context).toggleNode(node);
      },
      child: Text(node.content.toString()),
    );
  }

  @override
  State<CustomTreeView<T>> createState() => _CustomTreeViewState<T>();
}

class _CustomTreeViewState<T> extends State<CustomTreeView<T>>
    with _CustomTreeViewStateMixin<T, CustomTreeView<T>> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tree.length,
      itemBuilder: (context, index) {
        final node = widget.tree[index];
        return _buildNode(context, node);
      },
    );
  }
}

class CustomSliverTreeView<T> extends _CustomTreeView<T> {
  const CustomSliverTreeView({
    super.key,
    required super.tree,
    super.controller,
    super.nodeBuilder = CustomTreeView.defaultNodeBuilder,
    super.toggleAnimationStyle,
  });

  @override
  State<CustomSliverTreeView<T>> createState() =>
      _CustomSliverTreeViewState<T>();
}

class _CustomSliverTreeViewState<T> extends State<CustomSliverTreeView<T>>
    with _CustomTreeViewStateMixin<T, CustomSliverTreeView<T>> {
  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: widget.tree.length,
      itemBuilder: (context, index) {
        final node = widget.tree[index];
        return _buildNode(context, node);
      },
    );
  }
}

abstract class _CustomTreeView<T> extends StatefulWidget {
  const _CustomTreeView({
    super.key,
    required this.tree,
    required this.nodeBuilder,
    this.controller,
    this.toggleAnimationStyle,
  });

  final List<CustomTreeNode<T>> tree;
  final CustomTreeViewController? controller;
  final Widget Function(BuildContext, CustomTreeNode<T>) nodeBuilder;
  final AnimationStyle? toggleAnimationStyle;
}

mixin _CustomTreeViewStateMixin<T, C extends _CustomTreeView<T>> on State<C> {
  CustomTreeViewController get controller => _controller!;

  CustomTreeViewController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? CustomTreeViewController();
    _controller!._state = this;
  }

  Widget _buildNode(
    BuildContext context,
    CustomTreeNode<T> node,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.nodeBuilder(context, node),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: node.isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final node in node.children) _buildNode(context, node),
                  ],
                )
              : null,
        ),
      ],
    );
  }

  CustomTreeNode<T>? _getNode(T content, List<CustomTreeNode<T>> nodes) {
    final List<CustomTreeNode<T>> nextDepth = <CustomTreeNode<T>>[];
    for (final CustomTreeNode<T> node in nodes) {
      if (node.content == content) {
        return node;
      }
      if (node.children.isNotEmpty) {
        nextDepth.addAll(node.children);
      }
    }
    if (nextDepth.isNotEmpty) {
      return _getNode(content, nextDepth);
    }
    return null;
  }

  bool isExpanded(CustomTreeNode<T> node) {
    return _getNode(node.content, widget.tree)?.isExpanded ?? false;
  }

  void toggleNode(CustomTreeNode<T> node) {
    final n = _getNode(node.content, widget.tree);
    if (n != null) {
      setState(() {
        n._expanded = !n._expanded;
        for (final child in n.children) {
          child._depth = (n._depth ?? 0) + 1;
          child._parent = n;
        }
      });
    }
  }
}
