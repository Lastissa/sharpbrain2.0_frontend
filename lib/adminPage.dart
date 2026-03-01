import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sharpbrains/utils.dart';

class Adminpage extends ConsumerStatefulWidget {
  const Adminpage({super.key});

  @override
  ConsumerState<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends ConsumerState<Adminpage> {
  final _controller1 = TextEditingController();
  final _formController = GlobalKey<FormState>();
  bool updated = false;
  String url = '';

  @override
  Widget build(BuildContext context) {
    _controller1.text = 'http://127.0.0.1:8000/';
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => routerInstance.pop(),
            child: Icon(Icons.arrow_back),
          ),
          Row(
            children: [
              Icon(Icons.web_stories),
              Text('bACKEND URL: '),
              Expanded(
                child: Form(
                  key: _formController,
                  child: TextFormField(
                    enableSuggestions: true,

                    validator: (v) {
                      if (!_controller1.text.contains('/')) {
                        return 'invalid url';
                      } else if (_controller1.text.trim().isEmpty) {
                        return 'Cannot be Empty';
                      } else {
                        setState(() {
                          updated = true;
                        });
                        ref.read(backendUrl.notifier).state = _controller1.text;
                        return null;
                      }
                    },

                    controller: _controller1,
                    decoration: InputDecoration(hint: Text('Backend URl/')),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _formController.currentState?.validate();
                  if (_controller1.text.trim().isNotEmpty &&
                      _controller1.text.contains('/')) {
                    ref.read(backendUrl.notifier).state = _controller1.text
                        .trim();
                  }
                },

                child: Text('update'),
              ),
              ElevatedButton(
                onPressed: () => ref.invalidate(backendUrl),
                child: Text('Reset'),
              ),
            ],
          ),
          updated ? Text('Urls is now ${ref.read(backendUrl)}') : SizedBox(),
        ],
      ),
    );
  }
}

final backendUrl = StateProvider((ref) {
  return 'https://esta-sensate-unquickly.ngrok-free.dev/';
});
