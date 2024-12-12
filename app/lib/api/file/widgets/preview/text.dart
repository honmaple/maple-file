import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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
  })  : source = GRPC().previewURL(path),
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
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: FutureBuilder(
          future: _getText(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              return SingleChildScrollView(
                child: Text(snapshot.data ?? ""),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<String> _getText() async {
    switch (widget.sourceType) {
      case SourceType.file:
        return File(widget.source).readAsString();
      case SourceType.asset:
        return rootBundle.loadString(widget.source);
      case SourceType.network:
        try {
          final response = await http.get(Uri.parse(widget.source));
          if (response.statusCode == 200) {
            return utf8.decode(response.bodyBytes);
          }
        } catch (e) {
          print(e.toString());
        }
        return "Can't read this file";
    }
  }
}
