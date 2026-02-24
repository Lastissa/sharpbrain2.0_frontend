import 'package:flutter/material.dart';
import 'package:sharpbrains/utils.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  final formkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showpassword = false;

  void _submit() {
    if (formkey.currentState?.validate() ?? false) {
      routerInstance.go('/homepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Text('PRACTICE FORM'),
              InkWell(
                onTap: () => routerInstance.go('/homepage'),
                child: Icon(Icons.abc),
              ),
              TextFormField(
                controller: usernameController,
                validator: (v) =>
                    (usernameController.text.trim().isEmpty ||
                        !usernameController.text.contains('@') ||
                        !usernameController.text.contains('.'))
                    ? 'ogbeni, put this thing correctly nau'
                    : null,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _showpassword ? false : true,
                validator: (v) {
                  if (passwordController.text.length > 7) {
                    return null;
                  }
                  return 'ode, why your password too short';
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => (setState(() {
                      _showpassword == true
                          ? _showpassword = false
                          : _showpassword = true;
                    })),
                    icon: Icon(
                      _showpassword
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              ElevatedButton(onPressed: () => _submit(), child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
