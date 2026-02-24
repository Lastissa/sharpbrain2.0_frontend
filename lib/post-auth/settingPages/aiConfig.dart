import 'package:flutter/material.dart';
import 'package:sharpbrains/utils.dart';

class Aiconfig extends StatefulWidget {
  const Aiconfig({super.key});

  @override
  State<Aiconfig> createState() => _AiconfigState();
}

class _AiconfigState extends State<Aiconfig> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          IconButton(
            onPressed: () => routerInstance.pop(),
            icon: Icon(Icons.reset_tv_rounded),
          ),
        ],
      ),
    );
  }
}
