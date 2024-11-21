import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("404", style: TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: Text("未找到页面"),
      ),
    );
  }
}
