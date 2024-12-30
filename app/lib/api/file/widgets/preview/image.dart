import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_image_library/extended_image_library.dart' show File;

import 'source.dart';

class ImagePreview extends StatefulWidget {
  final BoxFit fit;
  final PreviewSource source;

  const ImagePreview({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
  });

  ImagePreview.file(
    io.File file, {
    super.key,
    this.fit = BoxFit.cover,
  }) : source = PreviewSource.file(file);

  ImagePreview.asset(
    String path, {
    super.key,
    this.fit = BoxFit.cover,
  }) : source = PreviewSource.asset(path);

  ImagePreview.network(
    String url, {
    super.key,
    this.fit = BoxFit.cover,
  }) : source = PreviewSource.network(url);

  ImagePreview.local(
    String path, {
    super.key,
    this.fit = BoxFit.cover,
  }) : source = PreviewSource.local(path);

  ImagePreview.remote(
    String path, {
    super.key,
    this.fit = BoxFit.cover,
  }) : source = PreviewSource.remote(path);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    switch (widget.source.sourceType) {
      case SourceType.file:
        return ExtendedImage.file(
          File(widget.source.source),
          fit: widget.fit,
          mode: ExtendedImageMode.gesture,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
      case SourceType.asset:
        return ExtendedImage.asset(
          widget.source.source,
          fit: widget.fit,
          mode: ExtendedImageMode.gesture,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
      case SourceType.network:
        return ExtendedImage.network(
          widget.source.source,
          fit: widget.fit,
          mode: ExtendedImageMode.gesture,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
    }
  }
}
