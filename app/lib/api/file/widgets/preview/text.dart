import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'source.dart';

class TextPreview extends StatefulWidget {
  final PreviewSource source;

  const TextPreview({
    super.key,
    required this.source,
  });

  TextPreview.file(
    io.File file, {
    super.key,
  }) : source = PreviewSource.file(file);

  TextPreview.asset(
    String path, {
    super.key,
  }) : source = PreviewSource.asset(path);

  TextPreview.network(
    String url, {
    super.key,
  }) : source = PreviewSource.network(url);

  TextPreview.local(
    String path, {
    super.key,
  }) : source = PreviewSource.local(path);

  TextPreview.remote(
    String path, {
    super.key,
  }) : source = PreviewSource.remote(path);

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
        width: double.infinity,
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
    switch (widget.source.sourceType) {
      case SourceType.file:
        return io.File(widget.source.source).readAsString();
      case SourceType.asset:
        return rootBundle.loadString(widget.source.source);
      case SourceType.network:
        try {
          final response = await http.get(Uri.parse(widget.source.source));
          if (response.statusCode == 200) {
            return utf8.decode(response.bodyBytes);
          }
        } catch (e) {
          return e.toString();
        }
        return "Can't read this file";
    }
  }
}
