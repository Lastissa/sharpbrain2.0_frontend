import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharpbrains/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(ProviderScope(child: Init()));
}

class Init extends ConsumerStatefulWidget {
  const Init({super.key});

  @override
  ConsumerState<Init> createState() => _InitState();
}

class _InitState extends ConsumerState<Init> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(ref.watch(devicesizeX), ref.watch(devicesizeY)),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routerInstance,

        builder: (context, child) => child!,
      ),
    );
  }
}
