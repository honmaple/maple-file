import 'dart:io';
import 'package:flutter/material.dart';

import 'package:maple_file/app/grpc.dart';

import 'source.dart';

class TextPreview extends StatefulWidget {
  final String source;
  final SourceType sourceType;

  const TextPreview({
    super.key,
    required this.source,
    required this.sourceType,
  });

  TextPreview.file(
    File file, {
    super.key,
  })  : source = file.path,
        sourceType = SourceType.file;

  const TextPreview.asset(
    String path, {
    super.key,
  })  : source = path,
        sourceType = SourceType.asset;

  const TextPreview.network(
    String url, {
    super.key,
  })  : source = url,
        sourceType = SourceType.network;

  const TextPreview.local(
    String path, {
    super.key,
  })  : source = path,
        sourceType = SourceType.file;

  TextPreview.remote(
    String path, {
    super.key,
  })  : source = "http://${GRPC().addr}/api/file/preview/blob?path=$path",
        sourceType = SourceType.network;

  @override
  State<TextPreview> createState() => _TextPreviewState();
}

class _TextPreviewState extends State<TextPreview> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return TextField(
              controller: _controller,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<String> _getText() async {
    return "";
  }
}
