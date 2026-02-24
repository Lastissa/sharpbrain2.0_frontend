import 'package:flutter/material.dart';
import 'package:sharpbrains/utils.dart';

class Seeourotherapp extends StatefulWidget {
  const Seeourotherapp({super.key});

  @override
  State<Seeourotherapp> createState() => _SeeourotherappState();
}

class _SeeourotherappState extends State<Seeourotherapp> {
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
