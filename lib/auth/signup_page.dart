import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sharpbrains/utils.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  void _submit() async {
    routerInstance.push('/splashscreenRegistrationPage');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainColor, toolbarHeight: 0),
      backgroundColor: const Color.fromARGB(255, 226, 240, 252),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: ref.watch(devicesizeY).h,
        width: ref.watch(devicesizeX).w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SvgPicture.string(
                '''<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'>
<defs><linearGradient id='g' x1='0' x2='1'><stop offset='0' stop-color='#ffff'/><stop offset='1' stop-color='#e0e0e0'/></linearGradient></defs>
<circle cx='50' cy='50' r='40' fill='url(#g)' opacity='0.18'/>
<text x='50%' y='55%' font-size='36' text-anchor='middle' fill='white' font-family='Arial' font-weight='700'>SB</text>
</svg>''',
                height: 100,
              ),
            ),
            Text(
              'Join SharpBrains',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _submit(),
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: Text(
                  'Create account',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/login'),
              child: Text(
                'Already have an account? Sign in',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
