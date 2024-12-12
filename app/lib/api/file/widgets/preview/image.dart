import 'dart:io';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import 'package:maple_file/app/grpc.dart';

import 'source.dart';

class ImagePreview extends StatefulWidget {
  final BoxFit fit;
  final String source;
  final SourceType sourceType;

  const ImagePreview({
    super.key,
    required this.source,
    required this.sourceType,
    this.fit = BoxFit.cover,
  });

  ImagePreview.file(
    File file, {
    super.key,
    this.fit = BoxFit.cover,
  })  : source = file.path,
        sourceType = SourceType.file;

  const ImagePreview.asset(
    String path, {
    super.key,
    this.fit = BoxFit.cover,
  })  : source = path,
        sourceType = SourceType.asset;

  const ImagePreview.network(
    String url, {
    super.key,
    this.fit = BoxFit.cover,
  })  : source = url,
        sourceType = SourceType.network;

  const ImagePreview.local(
    String path, {
    super.key,
    this.fit = BoxFit.cover,
  })  : source = path,
        sourceType = SourceType.file;

  ImagePreview.remote(
    String path, {
    super.key,
    this.fit = BoxFit.cover,
  })  : source = GRPC().previewURL(path),
        sourceType = SourceType.network;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    switch (widget.sourceType) {
      case SourceType.file:
        return ExtendedImage.file(
          File(widget.source),
          fit: widget.fit,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
      case SourceType.asset:
        return ExtendedImage.asset(
          widget.source,
          fit: widget.fit,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
      case SourceType.network:
        return ExtendedImage.network(
          widget.source,
          fit: widget.fit,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        );
    }
  }
}
