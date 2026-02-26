import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharpbrains/auth/reg.dart';
import 'package:sharpbrains/utils.dart';

class Registration extends ConsumerStatefulWidget {
  const Registration({super.key});

  @override
  ConsumerState<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState<Registration> {
  final reg1FormkKey = GlobalKey<FormState>();
  final reg2FormkKey = GlobalKey<FormState>();
  final reg3FormkKey = GlobalKey<FormState>();
  final reg4FormkKey = GlobalKey<FormState>();
  //REG1 text controllers
  final basicInfoSurnameController = TextEditingController();
  final basicInfoFirstnameController = TextEditingController();
  final basicInfoEmailController = TextEditingController();
  final basicInfoYearOfBirthController = TextEditingController();
  final basicInfoMonthOfBirthController = TextEditingController();
  final basicInfoDateOfBirthController = TextEditingController();

  //REG2  no need text controllers

  //REG3 text controllers
  final securityPasswordController = TextEditingController();

  String heading = 'BASIC INFO';
  int currentIndex = 0;
  void rf(int index) async {
    GlobalKey<FormState> currentKey;
    switch (currentIndex) {
      case 0:
        currentKey = reg1FormkKey;
        break;
      case 1:
        currentKey = reg2FormkKey;
        ref.read(userSurname.notifier).state = basicInfoSurnameController.text;
        ref.read(userFirstname.notifier).state =
            basicInfoFirstnameController.text;
        ref.read(userEmail.notifier).state = basicInfoEmailController.text;
        break;
      case 2:
        currentKey = reg3FormkKey;
        ref.read(userPassword.notifier).state = securityPasswordController.text;

        break;
      case 3:
        currentKey = reg4FormkKey;

        break;
      default:
        currentKey = reg1FormkKey;
    }
    if (currentKey.currentState?.validate() ?? false) {
      if (index <= 3) {
        setState(() {
          currentIndex = index;
          if (currentIndex == 1) {
            heading = 'EDUCATION DETAILS';
          } else if (currentIndex == 2) {
            heading = 'SECURITY ';
          }
          if (currentIndex == 3) {
            heading = 'NAME UNKNOWN';
          }
        });
      } else {
        notifier(
          context: context,
          duration: null,
          bg: mainColor,
          text: 'Creating Account...',
        );

        final c = await ref
            .read(formSubmission.future)
            .timeout(
              Duration(seconds: 60),
              onTimeout: () {
                return {"message": "Error"};
              },
            );

        // print(c?["message"]);
        await Future.delayed(Duration(milliseconds: 500));
        routerInstance.go("/");
        if (c["message"] == "success") {
          notifier(
            context: context,
            duration: Duration(seconds: 2),
            bg: mainColor,
            text: 'Account Created...',
          );
        } else {
          notifier(
            context: context,
            duration: Duration(seconds: 2),
            bg: mainColor,
            text: 'Could not create account, please try again',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //to make sure the method are called as soon as the user click create account in registration page
    ref.watch(coursesOfferedSaved);
    ref.watch(universityNameSaved);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        //Just to make sure we have not pop the page before now hence avoiding double trigger
        if (didPop) return;
        setState(() {
          if (currentIndex != 0) {
            currentIndex = currentIndex - 1;
          } else {
            routerInstance.go('/signup');
          }
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: mainColor, toolbarHeight: 0),
        body: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    progress(
                      active: currentIndex == 0 ? true : false,
                      width: ref.watch(devicesizeX).w,
                    ),
                    progress(
                      active: currentIndex == 1 ? true : false,
                      width: ref.watch(devicesizeX).w,
                    ),
                    progress(
                      active: currentIndex == 2 ? true : false,
                      width: ref.watch(devicesizeX).w,
                    ),
                    progress(
                      active: currentIndex == 3 ? true : false,
                      width: ref.watch(devicesizeX).w,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (currentIndex == 0) {
                          ref.invalidate(coursesOfferedSaved);
                          ref.invalidate(universityNameSaved);
                          ref.invalidate(jambSubjectCombinationSaved);
                          ref.invalidate(userSurname);
                          ref.invalidate(userFirstname);
                          ref.invalidate(userEmail);
                          ref.invalidate(userYearOfBirth);
                          ref.invalidate(userMonthOfBirth);
                          ref.invalidate(userDateOfBirth);
                          ref.invalidate(userUniversityName);
                          ref.invalidate(userDeptOfStudy);
                          ref.invalidate(userLevel);
                          ref.invalidate(userPassword);
                          ref.invalidate(otpStatus);
                          ref.invalidate(otp);
                          ref.invalidate(otpValue);
                          routerInstance.go('/signup');
                        } else if (currentIndex == 1) {
                          setState(() {
                            currentIndex = 0;
                            heading = 'BASIC INFO';
                          });
                        } else if (currentIndex == 2) {
                          setState(() {
                            currentIndex = 1;
                            heading = 'EDUCATION DETAILS';
                            ref.invalidate(otpStatus);
                            ref.invalidate(otp);
                            ref.invalidate(otpValue);
                            ref.invalidate(otpGotten);
                            ref.invalidate(onButtonPressed);
                          });
                        } else if (currentIndex == 3) {
                          setState(() {
                            currentIndex = 2;
                            heading = 'SECURITY';
                          });
                        }
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Spacer(flex: 90),
                    Text(
                      heading,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: mainColor,
                      ),
                    ),
                    Spacer(flex: 100),
                  ],
                ),
              ],
            ),

            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: [
                  Reg1(
                    formController: reg1FormkKey,
                    surnameController: basicInfoSurnameController,
                    firstnameController: basicInfoFirstnameController,
                    emailController: basicInfoEmailController,
                    isactive: currentIndex == 0 ? true : false,
                  ),
                  Reg2(
                    formController: reg2FormkKey,
                    isactive: currentIndex == 1 ? true : false,
                  ),
                  Reg3(
                    formController: reg3FormkKey,
                    passwordController: securityPasswordController,
                    isactive: currentIndex == 2 ? true : false,
                  ),
                  Reg4(
                    formController: reg4FormkKey,
                    isactive: currentIndex == 3 ? true : false,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavNext(
          onchanged: (index) => rf(index),
          width: ref.watch(devicesizeX).w,
          color: mainColor,
          index: currentIndex,
        ),
      ),
    );
  }
}

class BottomNavNext extends StatelessWidget {
  const BottomNavNext({
    super.key,
    required this.width,
    required this.color,
    required this.index,
    required this.onchanged,
  });

  final double width;
  final Color color;
  final int index;
  final ValueChanged<int> onchanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      padding: EdgeInsets.only(bottom: 5),
      width: 0.7 * width,
      child: ElevatedButton(
        onPressed: () => onchanged(index + 1),
        style: ElevatedButton.styleFrom(backgroundColor: mainColor),
        child: Text('Next', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

Widget progress({required bool active, required double width}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.only(top: 10),
    width: active ? 0.25 * width : 0.20 * width,
    height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: active ? Colors.deepPurple : mainColor,
      border: Border.all(color: active ? mainColor : mainColor),
    ),
  );
}
