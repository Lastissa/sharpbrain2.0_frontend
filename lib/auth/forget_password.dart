import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharpbrains/utils.dart';

// ignore: camel_case_types
class forgotPassword extends ConsumerStatefulWidget {
  const forgotPassword({super.key});

  @override
  ConsumerState<forgotPassword> createState() => _forgotPasswordState();
}

// ignore: camel_case_types
class _forgotPasswordState extends ConsumerState<forgotPassword> {
  final _formcontroller = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController confirmEmail = TextEditingController();

  void _send() {
    if (_formcontroller.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Otp on its way')));
      routerInstance.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainColor, toolbarHeight: 0),
      body: Form(
        key: _formcontroller,
        child: Column(
          children: [
            SizedBox(height: 0.1 * ref.watch(devicesizeY).h),
            Text(
              'If Email exist, a one time password will be sent to the email',
            ),
            TextFormField(
              controller: email,
              validator: (v) {
                if (!email.text.contains('@') || !email.text.contains('.com')) {
                  return 'Not a valid email';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Input Email address'),
            ),
            TextFormField(
              controller: confirmEmail,
              validator: (v) {
                if (confirmEmail.text != email.text) {
                  return 'Email do not match';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Confirm Email address'),
            ),
            ElevatedButton(
              onPressed: () => _send(),
              child: Text('Reset password'),
            ),
            ElevatedButton(
              onPressed: () => routerInstance.pop(),
              child: Text('cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
