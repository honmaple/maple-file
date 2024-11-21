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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      initialItemCount: _activeNodes.length,
      itemBuilder: (context, index, animation) {
        final CustomTreeNode<T> node = _activeNodes[index];
        return _buildNode(context, node, animation);
      },
    );
  }

  @override
  void _insertItem(int index) {
    _listKey.currentState?.insertItem(index);
  }

  @override
  void _removeItem(int index, CustomTreeNode<T> node) {
    _listKey.currentState?.removeItem(index, (context, animation) {
      return _buildNode(context, node, animation);
    });
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
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _activeNodes.length,
      itemBuilder: (context, index, animation) {
        final CustomTreeNode<T> node = _activeNodes[index];
        return _buildNode(context, node, animation);
      },
    );
  }

  @override
  void _insertItem(int index) {
    _listKey.currentState?.insertItem(index);
  }

  @override
  void _removeItem(int index, CustomTreeNode<T> node) {
    _listKey.currentState?.removeItem(index, (context, animation) {
      return _buildNode(context, node, animation);
    });
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

  List<CustomTreeNode<T>> _activeNodes = <CustomTreeNode<T>>[];

  @override
  void initState() {
    super.initState();

    _activeNodes = _treeToList();

    _controller = widget.controller ?? CustomTreeViewController();
    _controller!._state = this;
  }

  @override
  void didUpdateWidget(C oldWidget) {
    super.didUpdateWidget(oldWidget);

    _rebuild();
  }

  Widget _buildNode(
    BuildContext context,
    CustomTreeNode<T> node,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: widget.nodeBuilder(context, node),
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
      final index = _activeNodes.indexOf(n);
      setState(() {
        n._expanded = !n._expanded;

        _activeNodes = _treeToList();

        if (n._expanded) {
          _expand(index + 1, n);
        } else {
          _collapse(index + 1, n);
        }
      });
    }
  }

  List<CustomTreeNode<T>> _treeToList({
    int depth = 0,
    CustomTreeNode<T>? parent,
    List<CustomTreeNode<T>>? nodes,
  }) {
    List<CustomTreeNode<T>> result = [];

    nodes ??= widget.tree;
    for (final node in nodes) {
      node._depth = depth;
      node._parent = parent;

      result.add(node);

      if (node.children.isNotEmpty && node.isExpanded) {
        result.addAll(_treeToList(
          depth: depth + 1,
          nodes: node.children,
          parent: node,
        ));
      }
    }
    return result;
  }

  int _expand(int index, CustomTreeNode<T> node) {
    int length = 0;

    for (var i = 0; i <= node.children.length - 1; i++) {
      _insertItem(index + length + i);

      final child = node.children[i];
      if (child.isExpanded) {
        length += _expand(index + i + 1, child);
      }
    }
    return length + node.children.length;
  }

  void _collapse(int index, CustomTreeNode<T> node) {
    for (var i = node.children.length - 1; i >= 0; i--) {
      final child = node.children[i];
      if (child.isExpanded) {
        _collapse(index + i + 1, child);
      }
      _removeItem(index + i, child);
    }
  }

  void _rebuild() {
    for (int i = _activeNodes.length - 1; i >= 0; i--) {
      final child = _activeNodes[i];
      _removeItem(i, child);
    }

    _activeNodes = _treeToList();

    for (int i = 0; i <= _activeNodes.length - 1; i++) {
      _insertItem(i);
    }
  }

  void _insertItem(int index);
  void _removeItem(int index, CustomTreeNode<T> node);
}
