import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sharpbrains/utils.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  DateTime? _backPressedCount;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    ref.read(loginUserName.notifier).state = _emailController.text;
    ref.read(loginPassword.notifier).state = _passwordController.text;

    if (_formKey.currentState?.validate() ?? false) {
      routerInstance.push('/splashscreenPostLogIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: ((didPop, holder) {
        if (didPop) return;
        if (DateTime.now().difference(_backPressedCount ?? DateTime.now()) >
                Duration(seconds: 2) ||
            _backPressedCount == null) {
          _backPressedCount = DateTime.now();
          return notifier(
            context: context,
            bg: mainColor,
            text: 'Press again to Quit',
            duration: Duration(seconds: 2),
          );
        } else {
          SystemNavigator.pop();
        }
      }),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: mainColor),
        body: Container(
          width: ref.read(devicesizeX).w,
          height: ref.read(devicesizeY).h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 18),
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 28),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildRoundedField(
                          controller: _emailController,
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              (v == null ||
                                  !v.contains('@') ||
                                  !v.toLowerCase().contains('.com'))
                              ? 'Enter a valid email'
                              : null,
                          prefix: const Icon(
                            Icons.email_outlined,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRoundedField(
                          controller: _passwordController,
                          hint: 'Password',
                          obscureText: !_showPassword,
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Minimum 6 characters'
                              : null,
                          prefix: const Icon(
                            Icons.lock_outline,
                            color: Colors.white70,
                          ),
                          suffix: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     SizedBox(
                        //       child: ElevatedButton(
                        //         onPressed: () {},
                        //         child: Text("Sign In"),
                        //       ),
                        //     ),
                        //     Container(
                        //       padding: EdgeInsets.all(9),
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         shape: BoxShape.circle,
                        //       ),
                        //       child: SvgPicture.string(
                        //         '''<svg viewBox="-3 0 262 262" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M255.878 133.451c0-10.734-.871-18.567-2.756-26.69H130.55v48.448h71.947c-1.45 12.04-9.283 30.172-26.69 42.356l-.244 1.622 38.755 30.023 2.685.268c24.659-22.774 38.875-56.282 38.875-96.027" fill="#4285F4"></path><path d="M130.55 261.1c35.248 0 64.839-11.605 86.453-31.622l-41.196-31.913c-11.024 7.688-25.82 13.055-45.257 13.055-34.523 0-63.824-22.773-74.269-54.25l-1.531.13-40.298 31.187-.527 1.465C35.393 231.798 79.49 261.1 130.55 261.1" fill="#34A853"></path><path d="M56.281 156.37c-2.756-8.123-4.351-16.827-4.351-25.82 0-8.994 1.595-17.697 4.206-25.82l-.073-1.73L15.26 71.312l-1.335.635C5.077 89.644 0 109.517 0 130.55s5.077 40.905 13.925 58.602l42.356-32.782" fill="#FBBC05"></path><path d="M130.55 50.479c24.514 0 41.05 10.589 50.479 19.438l36.844-35.974C195.245 12.91 165.798 0 130.55 0 79.49 0 35.393 29.301 13.925 71.947l42.211 32.783c10.59-31.477 39.891-54.251 74.414-54.251" fill="#EB4335"></path></g></svg>''',
                        //         width: 25,
                        //         height: 25,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_emailController.text.toLowerCase() ==
                                            'admin' &&
                                        _passwordController.text
                                                .toLowerCase() ==
                                            'admin') {
                                      routerInstance.push('/adminpage');
                                    }

                                    return _submit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: ref.read(devicesizeX) * 0.02.w),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.transparent,
                                // padding: EdgeInsets.all(10.r),
                                height: 52,

                                child: ElevatedButton(
                                  clipBehavior: Clip.antiAlias,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {},
                                  child: SizedBox(
                                    child: SvgPicture.string(
                                      fit: BoxFit.cover,
                                      width: 28,
                                      height: 28,
                                      '''<svg viewBox="-3 0 262 262" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M255.878 133.451c0-10.734-.871-18.567-2.756-26.69H130.55v48.448h71.947c-1.45 12.04-9.283 30.172-26.69 42.356l-.244 1.622 38.755 30.023 2.685.268c24.659-22.774 38.875-56.282 38.875-96.027" fill="#4285F4"></path><path d="M130.55 261.1c35.248 0 64.839-11.605 86.453-31.622l-41.196-31.913c-11.024 7.688-25.82 13.055-45.257 13.055-34.523 0-63.824-22.773-74.269-54.25l-1.531.13-40.298 31.187-.527 1.465C35.393 231.798 79.49 261.1 130.55 261.1" fill="#34A853"></path><path d="M56.281 156.37c-2.756-8.123-4.351-16.827-4.351-25.82 0-8.994 1.595-17.697 4.206-25.82l-.073-1.73L15.26 71.312l-1.335.635C5.077 89.644 0 109.517 0 130.55s5.077 40.905 13.925 58.602l42.356-32.782" fill="#FBBC05"></path><path d="M130.55 50.479c24.514 0 41.05 10.589 50.479 19.438l36.844-35.974C195.245 12.91 165.798 0 130.55 0 79.49 0 35.393 29.301 13.925 71.947l42.211 32.783c10.59-31.477 39.891-54.251 74.414-54.251" fill="#EB4335"></path></g></svg>''',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: Text(
                            'Create an account',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/forgotPassword'),
                          child: Text(
                            'Forgotten Password? ',
                            style: TextStyle(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedField({
    required TextEditingController controller,
    required String hint,
    Widget? prefix,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,

        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          prefixIcon: prefix == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: prefix,
                ),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}

final loginUserName = StateProvider<String>((ref) {
  return '';
});
final loginPassword = StateProvider<String>((ref) {
  return '';
});
