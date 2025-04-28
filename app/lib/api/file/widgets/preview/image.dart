import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_image_library/extended_image_library.dart' show File;

import 'package:maple_file/common/widgets/responsive.dart';

import 'source.dart';

class ImagePreview extends StatefulWidget {
  final BoxFit fit;
  final PreviewSourceImpl source;

  const ImagePreview({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    switch (widget.source.type) {
      case SourceType.file:
        return ExtendedImage.file(
          File(widget.source.path),
          fit: widget.fit,
          mode: ExtendedImageMode.gesture,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
      case SourceType.asset:
        return ExtendedImage.asset(
          widget.source.path,
          fit: widget.fit,
          mode: ExtendedImageMode.gesture,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
      case SourceType.network:
        return ExtendedImage.network(
          widget.source.path,
          fit: widget.fit,
          mode: ExtendedImageMode.gesture,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
    }
  }
}

class ImageListPreview extends StatefulWidget {
  final int index;
  final List<PreviewSourceImpl> sources;
  final Function(int)? onChanged;

  const ImageListPreview({
    super.key,
    required this.sources,
    this.index = 0,
    this.onChanged,
  });

  @override
  State<ImageListPreview> createState() => _ImageListPreviewState();
}

class _ImageListPreviewState extends State<ImageListPreview> {
  late final PageController _pageController;

  int _currentIndex = 0;

  bool _fullscreen = false;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.index;
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          itemCount: widget.sources.length,
          itemBuilder: (BuildContext context, int index) {
            final source = widget.sources[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _fullscreen = !_fullscreen;
                });
              },
              child: ImagePreview(
                source: source,
                fit: BoxFit.contain,
              ),
            );
          },
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
            widget.onChanged?.call(index);
          },
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("${_currentIndex + 1}/${widget.sources.length}"),
          ),
        ),
        if (!Breakpoint.isSmall(context))
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.chevron_left, size: 32),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_currentIndex == 0) {
                    _pageController.jumpToPage(
                      widget.sources.length - 1,
                    );
                  } else {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
            ),
          ),
        if (!Breakpoint.isSmall(context))
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.chevron_right, size: 32),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_currentIndex == widget.sources.length - 1) {
                    _pageController.jumpToPage(0);
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  }
                },
              ),
            ),
          ),
      ],
    );
  }
}
