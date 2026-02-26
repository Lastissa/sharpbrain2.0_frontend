import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharpbrains/utils.dart';

class Reg1 extends ConsumerStatefulWidget {
  // ignore: prefer_typing_uninitialized_variables, strict_top_level_inference
  final formController;
  final TextEditingController surnameController;
  final TextEditingController firstnameController;
  final TextEditingController emailController;
  final isactive;

  const Reg1({
    super.key,
    required this.formController,
    required this.surnameController,
    required this.firstnameController,
    required this.emailController,
    this.isactive,
  });

  @override
  ConsumerState<Reg1> createState() => _Reg1State();
}

class _Reg1State extends ConsumerState<Reg1> {
  // final TextEditingController _nameController = TextEditingController();

  // final TextEditingController _emailController = TextEditingController();

  bool monthOfBirthisEnabled = true;
  //to make sure no changing is done one a month is selected, this way, i dont have to worry about month chosed or day of the month lenght
  String? dayOfBirth;
  String? monthOfBirth;
  String? yearOfBirth;

  int year = DateTime.now().year;
  //use for knowing the limit of years to show for the dropdownmwnu NB: year != year of birth

  bool startSpinning = false;
  Timer? debounce;
  void google() {}
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formController,
      child: Container(
        color: Colors.white,
        padding: EdgeInsetsGeometry.all(5),
        height: 0.7 * ref.watch(devicesizeY).h,
        width: ref.watch(devicesizeX).w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => (),
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: SizedBox(
                  width: .4 * ref.watch(devicesizeX).w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(
                        '''<svg viewBox="-3 0 262 262" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M255.878 133.451c0-10.734-.871-18.567-2.756-26.69H130.55v48.448h71.947c-1.45 12.04-9.283 30.172-26.69 42.356l-.244 1.622 38.755 30.023 2.685.268c24.659-22.774 38.875-56.282 38.875-96.027" fill="#4285F4"></path><path d="M130.55 261.1c35.248 0 64.839-11.605 86.453-31.622l-41.196-31.913c-11.024 7.688-25.82 13.055-45.257 13.055-34.523 0-63.824-22.773-74.269-54.25l-1.531.13-40.298 31.187-.527 1.465C35.393 231.798 79.49 261.1 130.55 261.1" fill="#34A853"></path><path d="M56.281 156.37c-2.756-8.123-4.351-16.827-4.351-25.82 0-8.994 1.595-17.697 4.206-25.82l-.073-1.73L15.26 71.312l-1.335.635C5.077 89.644 0 109.517 0 130.55s5.077 40.905 13.925 58.602l42.356-32.782" fill="#FBBC05"></path><path d="M130.55 50.479c24.514 0 41.05 10.589 50.479 19.438l36.844-35.974C195.245 12.91 165.798 0 130.55 0 79.49 0 35.393 29.301 13.925 71.947l42.211 32.783c10.59-31.477 39.891-54.251 74.414-54.251" fill="#EB4335"></path></g></svg>''',
                        height: 20,
                      ),
                      Text(
                        ' SignUp',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded(child: Container(color: Colors.red)),
              const SizedBox(height: 12),
              Container(
                width: ref.watch(devicesizeX).w,
                height: ref.watch(devicesizeY) * 0.65.h,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(flex: 1),

                    _field(
                      controller: widget.surnameController,

                      hint: 'Surname',
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter your surname'
                          : null,
                      width: ref.watch(devicesizeX),
                    ),
                    Spacer(flex: 1),

                    _field(
                      controller: widget.firstnameController,
                      hint: 'First Name',
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter your firstName'
                          : null,
                      width: ref.watch(devicesizeX),
                    ),
                    Spacer(flex: 1),
                    // _field(
                    //   controller: widget.emailController,
                    //   keyboard: TextInputType.emailAddress,
                    //   hint: 'Email',
                    //   icon: Icons.email_outlined,
                    //   validator: (v) {
                    //     if (v == null ||
                    //         !v.toLowerCase().contains('@gmail.com')) {
                    //       return 'Enter a valid email';
                    //     }
                    //     //i do not want to be creating another view for judt veryfying if a user email exist, so i will just use the "no user" and "incorrect" to check if they exist and then put at the buttom
                    //     // else()
                    //     return null;
                    //   },
                    //   width: ref.watch(devicesizeX),
                    Row(
                      children: [
                        SizedBox(
                          width: 0.9 * ref.read(devicesizeX).w,
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.contains("@gmail.com")) {
                                if (!mounted) return;
                                if (debounce?.isActive ?? false) return;
                                if (!mounted) return;
                                Timer(Duration(seconds: 1), () async {
                                  final c = await ref.read(
                                    userLoginCheck({
                                      "email": value,
                                      "password": "",
                                    }).future,
                                  );
                                  if (!mounted) return;
                                  if (c['message'] == "wrong password") {
                                    startSpinning = true;

                                    // if (mounted) {
                                    //   Timer.periodic(Duration(seconds: 3), (
                                    //     holder,
                                    //   ) {
                                    //     return notifier(
                                    //       context: GlobalKey(),
                                    //       duration: Duration(seconds: 5),
                                    //       bg: mainColor,
                                    //       text:
                                    //           "EMAIL ALREADY EXIST, LOGIN ISTEAD",
                                    //     );
                                    //   });
                                    // }
                                  }
                                  if (!mounted) return;
                                  print(c);
                                });
                                // } else {
                                //   setState(() {
                                //     startSpinning = false;
                                //   });
                                startSpinning = false;
                              }
                              // print(value);
                            },
                            keyboardType: TextInputType.emailAddress,
                            controller: widget.emailController,
                            obscureText: false,
                            validator: (v) {
                              if (v == null ||
                                  !v.toLowerCase().contains('@gmail.com')) {
                                return 'Enter a valid email';
                              }
                              //i do not want to be creating another view for judt veryfying if a user email exist, so i will just use the "no user" and "incorrect" to check if they exist and then put at the buttom
                              else if (startSpinning) {
                                return 'Email already exist, Login Istead';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusColor: Color(0xFFFFA001),

                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                        ),
                        //   startSpinning
                        //       ? CircularProgressIndicator()
                        //       : Container(
                        //           width: 10,
                        //           height: 20,
                        //           color: Colors.red,
                        //         ),
                      ],
                    ),
                    Spacer(flex: 1),

                    Row(
                      children: [
                        SizedBox(
                          width: 0.9 * ref.watch(devicesizeX).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 0.28 * ref.watch(devicesizeX).w,
                                child: DropdownButtonFormField(
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Required';
                                    } else {
                                      return null;
                                    }
                                  },
                                  isExpanded: true,
                                  hint: Text('Year'),
                                  items: List.generate(
                                    35,
                                    (index) => DropdownMenuItem(
                                      value: year - index - minimumAgetoUseApp,
                                      child: Text(
                                        (year - index - minimumAgetoUseApp)
                                            .toString(),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      yearOfBirth = value.toString();
                                      ref.read(userYearOfBirth.notifier).state =
                                          value.toString();
                                    });
                                  },
                                  selectedItemBuilder: (context) =>
                                      List.generate(
                                        35,
                                        (index) => Text(
                                          (year - index - minimumAgetoUseApp)
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                ),
                              ),

                              SizedBox(
                                width: 0.28 * ref.watch(devicesizeX).w,
                                child: DropdownButtonFormField(
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Required';
                                    } else {
                                      return null;
                                    }
                                  },
                                  isExpanded: true,
                                  initialValue: monthOfBirth,
                                  hint: Text('Month'),
                                  items: List.generate(
                                    monthLenght.keys.length,
                                    (index) => DropdownMenuItem(
                                      value:
                                          ((monthLenght.keys.toList())[index])
                                              .toString(),
                                      child: Text(
                                        ((monthLenght.keys.toList())[index])
                                            .toString()
                                            .toUpperCase(),
                                      ),
                                    ),
                                  ),
                                  onChanged: monthOfBirthisEnabled
                                      ? (value) {
                                          setState(() {
                                            ref
                                                    .read(
                                                      userMonthOfBirth.notifier,
                                                    )
                                                    .state =
                                                value?.toString() ?? '';
                                            monthOfBirth = value as String?;
                                            monthOfBirthisEnabled = false;
                                            ref
                                                    .read(
                                                      userMonthOfBirth.notifier,
                                                    )
                                                    .state =
                                                value as String;
                                          });
                                        }
                                      : null,
                                  selectedItemBuilder: (context) =>
                                      List.generate(
                                        monthLenght.keys.length,
                                        (index) => Text(
                                          ((monthLenght.keys.toList())[index])
                                              .toString(),
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: 0.28 * ref.watch(devicesizeX).w,
                                child: DropdownButtonFormField(
                                  validator: (v) {
                                    if (v == null) {
                                      return 'Required';
                                    } else {
                                      return null;
                                    }
                                  },
                                  isExpanded: true,
                                  hint: Text('Date'),
                                  items: List.generate(
                                    monthOfBirth != null
                                        ? monthLenght[monthOfBirth]!
                                              .toList()
                                              .length
                                        : 0,
                                    (index) {
                                      if (monthOfBirth != null) {
                                        return DropdownMenuItem(
                                          value: monthLenght[monthOfBirth]!
                                              .toList()[index]
                                              .toString(),
                                          child: Text(
                                            monthLenght[monthOfBirth]!
                                                .toList()[index]
                                                .toString(),
                                          ),
                                        );
                                      } else {
                                        //unreachable cos i have set the alternate lenght to zero should incase the month is null
                                        return DropdownMenuItem(
                                          value: 'month req',
                                          child: Text('Month required'),
                                        );
                                      }
                                    },
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      dayOfBirth = value;
                                      ref.read(userDateOfBirth.notifier).state =
                                          value?.toString() ?? '';
                                    });
                                  },
                                  selectedItemBuilder: (context) => List.generate(
                                    monthOfBirth != null
                                        ? monthLenght[monthOfBirth]!
                                              .toList()
                                              .length
                                        : 0,
                                    (index) {
                                      if (monthOfBirth != null) {
                                        return Text(
                                          monthLenght[monthOfBirth]!
                                              .toList()[index]
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      } else {
                                        //unreachable cos i hav set the alternate lenght to zero should incase the month is null

                                        return Text(
                                          'month req',
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(flex: 4),
                    Text(
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                      '*We will never share, sell, or leak your personal information to any third-party application. Your data is securely stored and protected with us.*',
                    ),
                    Spacer(flex: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Reg2 extends ConsumerStatefulWidget {
  // ignore: strict_top_level_inference
  final formController;
  final isactive;

  const Reg2({super.key, required this.formController, required this.isactive});

  @override
  ConsumerState<Reg2> createState() => _Reg2State();
}

class _Reg2State extends ConsumerState<Reg2> {
  Key _keyForUniDropDown = UniqueKey();
  Key __keyForDeptDropDown = UniqueKey();
  Key _keyForLevelDropDown = UniqueKey();
  bool uniDdropDownisActive = true;
  bool userIsAspirant = false;
  String? _firstSubjectChosen;
  String? _secondSubjectChosen;
  String? _thirdSubjectChosen;
  String? _fourthSubjectChosen;
  Future mySubjectConfirmFunc() async {
    await Future.doWhile(() async {
      if (widget.formController?.currentState?.validate()) {
        return false;
      }
      await Future.delayed(Duration(hours: 24));
      return false;
    });
    if (widget.formController?.currentState?.validate()) {
      List coreSubList = [];
      if (ref.read(userUniversityName).length > 1 &&
          ref.read(userDeptOfStudy).length > 1) {
        for (Map i in ref.read(jambSubjectCombinationSaved).value!) {
          if (i['uni_name'] == ref.read(userUniversityName) &&
              i['course_name'] == ref.read(userDeptOfStudy)) {
            coreSubList = i['core_subjects'];
            bool present = coreSubList.every(
              (items) => [
                _firstSubjectChosen,
                _secondSubjectChosen,
                _thirdSubjectChosen,
                _fourthSubjectChosen,
              ].contains(items),
            );
            if (present) {
              return 'You have chosen the right subject combination';
            } else {
              return 'your subject combination is not right';
            }
          }
        }
        return 'internal issue';
      }

      return 'data gotten';
    } else {
      return '';
    }
  }

  List subjectJambOffers() {
    List listToUse = [];
    if (ref.read(userUniversityName).length > 1 ||
        ref.read(userDeptOfStudy).length > 1) {
      for (Map i in ref.read(jambSubjectCombinationSaved).value!) {
        if (i['uni_name'] == ref.read(userUniversityName) &&
            i['course_name'] == ref.read(userDeptOfStudy)) {
          listToUse = i['subject_combination'];
        }
      }
    }
    return listToUse;
  }

  @override
  Widget build(BuildContext context) {
    final universityNameWatcher = ref.watch(universityNameSaved);
    final coursesWatcher = ref.watch(coursesOfferedSaved);
    return RefreshIndicator(
      displacement: 0,
      elevation: 0,
      onRefresh: () {
        ref.invalidate(userLevel);

        setState(() {
          _keyForUniDropDown = UniqueKey();
          __keyForDeptDropDown = UniqueKey();
          _keyForLevelDropDown = UniqueKey();
          uniDdropDownisActive = true;
        });
        return Future(() async {
          ref.invalidate(userUniversityName);
          ref.invalidate(userDeptOfStudy);
          // widget.formController?.currentState?.validate();
        });
      },
      child: Form(
        key: widget.formController,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: ref.watch(devicesizeX).w,
            height: ref.watch(devicesizeY).h,
            child: Column(
              children: [
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       uniDdropDownisActive = true;
                //       pageRefreshed = true;
                //     });
                //     widget.formController?.currentState?.reset();
                //     ref.invalidate(userUniversityName);
                //     ref.invalidate(userDeptOfStudy);
                //     widget.formController?.currentState?.validate();
                //   },
                //   child: Icon(Icons.refresh, size: ref.watch(devicesizeX) * 0.1),
                // ),
                Spacer(flex: 1),

                universityNameWatcher.when(
                  data: (List<Map<String, dynamic>> data) {
                    return DropdownButtonFormField(
                      key: _keyForUniDropDown,
                      validator: (v) {
                        if ((ref.read(userUniversityName).isEmpty &&
                            widget.isactive)) {
                          return 'Please select institution';
                        }
                        return null;
                      },
                      isExpanded:
                          true, //this is what force the selecteditembutton to be at the mercy of the constraint
                      hint: Text('Institution Name'),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.school),
                      ),
                      // initialValue: ref.read(userUniversityName),
                      items: List.generate(
                        data.length,
                        (index) => DropdownMenuItem(
                          value: data[index]['name_of_universities'],
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            data[index]['name_of_universities']!,
                          ),
                        ),
                      ),
                      //This here is used just to edit the text in the dropdownbutton
                      selectedItemBuilder: (BuildContext content) {
                        return List.generate(
                          data.length,
                          (index) => Text(
                            data[index]['name_of_universities'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                      onChanged: uniDdropDownisActive
                          ? (value) {
                              value == null ? value = '' : '';
                              setState(() {
                                ref.read(userUniversityName.notifier).state =
                                    value as String;
                                uniDdropDownisActive = false;
                              });
                            }
                          : null,
                    );
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return Text('Error : ${error.toString()}');
                  },
                  loading: () {
                    return Text('Please, GO BACK TO SIGNUP PAGE');
                  },
                ),
                Spacer(flex: 1),

                coursesWatcher.when(
                  data: (List<Map<dynamic, dynamic>>? data) {
                    int neededIndex = 0;
                    for (var i in data!) {
                      if (i['name_of_uni'] == ref.read(userUniversityName)) {
                        neededIndex = data.indexOf(i);
                        break;
                      }
                    }
                    return DropdownButtonFormField(
                      key: __keyForDeptDropDown,
                      validator: (v) {
                        if (ref.read(userDeptOfStudy).isEmpty) {
                          return 'Please select institution';
                        }
                        return null;
                      },
                      isExpanded: true,
                      hint: Text('Select Department'),

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      items: List.generate(
                        ref.read(userUniversityName).isNotEmpty
                            ? data[neededIndex]["courses_offered"].length
                            : 0,
                        (index) {
                          return DropdownMenuItem(
                            value: (data[neededIndex]["courses_offered"][index])
                                .toString(),
                            child: Text(
                              data[neededIndex]["courses_offered"][index] ??
                                  'Institution Name Required ',
                            ),
                          );
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          ref.read(userDeptOfStudy.notifier).state = value
                              .toString();
                        });
                      },
                      selectedItemBuilder: (context) {
                        return List.generate(
                          ref.read(userUniversityName).isNotEmpty
                              ? data[neededIndex]["courses_offered"].length
                              : 0,
                          (index) => Text(
                            (data[neededIndex]["courses_offered"][index])
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    );
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return Text('Fatal Error');
                  },
                  loading: () {
                    return Text('PLEASE, GO BACK TO HOME PAGE');
                  },
                ),
                Spacer(flex: 1),
                DropdownButtonFormField(
                  key: _keyForLevelDropDown,
                  validator: (v) {
                    if (ref.read(userLevel).isEmpty) {
                      return 'Please select level';
                    }
                    return null;
                  },
                  isExpanded: true,
                  hint: Text('Aspirant / Level'),
                  decoration: InputDecoration(prefixIcon: Icon(Icons.layers)),
                  items: List.generate(
                    ref.read(userDeptOfStudy).isNotEmpty ? 6 : 0,
                    (index) {
                      if (index == 0) {
                        return DropdownMenuItem(
                          value: 'Aspirant',
                          child: Text('Aspirant'),
                        );
                      } else {
                        return DropdownMenuItem(
                          value: '${index}00L',
                          child: Text('${index}00L'),
                        );
                      }
                    },
                  ),
                  onChanged: (value) {
                    value ?? (value = '');
                    setState(() {
                      ref.read(userLevel.notifier).state = value.toString();
                      if (value?.toLowerCase() == 'aspirant') {
                        userIsAspirant = true;
                      } else {
                        userIsAspirant = false;
                      }
                    });
                  },
                  selectedItemBuilder: (context) {
                    return [
                      Text('Aspirant', overflow: TextOverflow.ellipsis),
                      Text('100L', overflow: TextOverflow.ellipsis),
                      Text('200L', overflow: TextOverflow.ellipsis),
                      Text('300L', overflow: TextOverflow.ellipsis),
                      Text('400L', overflow: TextOverflow.ellipsis),
                      Text('500L', overflow: TextOverflow.ellipsis),
                    ];
                  },
                ),
                const SizedBox(height: 19),
                Column(
                  children: List.generate(
                    ref.read(userLevel).toLowerCase() == 'aspirant' ? 1 : 0,
                    (index) => Column(
                      children: [
                        Text(
                          '''Choose your jamb subject combination to see if you are eligible for your choice of institution and course ''',
                        ),
                        DropdownButtonFormField(
                          validator: (v) {
                            if (v == null) {
                              return 'Choose your jamb subject...';
                            } else {
                              return null;
                            }
                          },
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'First Subject',
                            prefixIcon: Icon(Icons.subject),
                          ),
                          items: List.generate(
                            subjectJambOffers().isNotEmpty
                                ? subjectJambOffers().length
                                : 0,
                            (index) {
                              return DropdownMenuItem(
                                value: ((List<String>.from(
                                  subjectJambOffers(),
                                )))[index].toLowerCase(),
                                child: Text(
                                  ((List<String>.from(
                                    subjectJambOffers(),
                                  )))[index],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                          onChanged: (value) {
                            setState(() {
                              _firstSubjectChosen = value;
                              // _subjectJambOffers.remove(value);
                            });
                          },
                          selectedItemBuilder: (context) => List.generate(
                            subjectJambOffers().isNotEmpty
                                ? subjectJambOffers().length
                                : 0,
                            (index) => Text(
                              ((List<String>.from(subjectJambOffers())))[index],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        DropdownButtonFormField(
                          validator: (v) {
                            if (v == null) {
                              return 'Choose your jamb subject...';
                            } else if (v == _firstSubjectChosen) {
                              return 'This subject have been selected, please change';
                            } else {
                              return null;
                            }
                          },
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Second Subject',
                            prefixIcon: Icon(Icons.subject),
                          ),
                          items: List.generate(
                            subjectJambOffers().length > 0
                                ? subjectJambOffers().length
                                : 0,
                            (index) => DropdownMenuItem(
                              value: ((List<String>.from(
                                subjectJambOffers(),
                              )))[index].toLowerCase(),
                              child: Text(
                                ((List<String>.from(
                                  subjectJambOffers(),
                                )))[index],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _secondSubjectChosen = value;
                              // _subjectJambOffers.remove(value);
                            });
                          },
                          selectedItemBuilder: (context) => List.generate(
                            subjectJambOffers().length > 0
                                ? subjectJambOffers().length
                                : 0,
                            (index) => Text(
                              ((List<String>.from(subjectJambOffers())))[index],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DropdownButtonFormField(
                          validator: (v) {
                            if (v == null) {
                              return 'Choose your jamb subject...';
                            } else if (v == _secondSubjectChosen ||
                                v == _firstSubjectChosen) {
                              return 'This subject have been selected, please change';
                            } else {
                              return null;
                            }
                          },
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Third Subject',
                            prefixIcon: Icon(Icons.subject),
                          ),
                          items: List.generate(
                            subjectJambOffers().length > 0
                                ? subjectJambOffers().length
                                : 0,
                            (index) => DropdownMenuItem(
                              value: ((List<String>.from(
                                subjectJambOffers(),
                              )))[index].toLowerCase(),
                              child: Text(
                                ((List<String>.from(
                                  subjectJambOffers(),
                                )))[index],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _thirdSubjectChosen = value;
                              // _subjectJambOffers.remove(value);
                            });
                          },
                          selectedItemBuilder: (context) => List.generate(
                            subjectJambOffers().length > 0
                                ? subjectJambOffers().length
                                : 0,
                            (index) => Text(
                              ((List<String>.from(subjectJambOffers())))[index],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DropdownButtonFormField(
                          initialValue: _fourthSubjectChosen,
                          validator: (v) {
                            if (v == null) {
                              return 'Choose your jamb subject...';
                            } else if (v == _thirdSubjectChosen ||
                                v == _secondSubjectChosen ||
                                v == _firstSubjectChosen) {
                              return 'This subject have been selected, please change';
                            } else {
                              return null;
                            }
                          },
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Fourth Subject',
                            prefixIcon: Icon(Icons.subject),
                          ),
                          items: List.generate(
                            subjectJambOffers().length > 0
                                ? subjectJambOffers().length
                                : 0,
                            (index) => DropdownMenuItem(
                              value: ((List<String>.from(
                                subjectJambOffers(),
                              )))[index].toLowerCase(),
                              child: Text(
                                ((List<String>.from(
                                  subjectJambOffers(),
                                )))[index],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // _subjectJambOffers.remove(value);
                              _fourthSubjectChosen = value;
                            });
                          },
                          selectedItemBuilder: (context) => List.generate(
                            subjectJambOffers().length > 0
                                ? subjectJambOffers().length
                                : 0,
                            (index) => Text(
                              ((List<String>.from(subjectJambOffers())))[index],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder(
                          future: mySubjectConfirmFunc(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              return Text(
                                textAlign: TextAlign.center,
                                snapshot.data.toString().toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.w600),
                              );
                            } else {
                              return Center(
                                child: Text('Something don sup, go look code'),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Spacer(flex: 3),
                Text(
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                  'We only collect academic information necessary to tailor your experience. Your information is safe and will never be shared',
                ),
                Spacer(flex: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Reg3 extends ConsumerStatefulWidget {
  final formController;
  final TextEditingController passwordController;
  final isactive;
  const Reg3({
    super.key,
    this.formController,
    required this.isactive,
    required this.passwordController,
  });

  @override
  ConsumerState<Reg3> createState() => _Reg3State();
}

class _Reg3State extends ConsumerState<Reg3> {
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formController,
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.all(10),
        height: ref.watch(devicesizeY).h,
        width: ref.watch(devicesizeX).w,
        child: Column(
          children: [
            const SizedBox(height: 12),
            _field(
              controller: widget.passwordController,
              keyboard: TextInputType.visiblePassword,
              hint: 'Password',
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) {
                if ((v == null || v.isEmpty)) {
                  return 'Required';
                } else {
                  if (v.length < 6) {
                    return 'Password too short';
                  }
                }
                return null;
              },
              width: ref.watch(devicesizeX),
            ),
            const SizedBox(height: 12),
            _field(
              controller: _confirmController,
              keyboard: TextInputType.visiblePassword,
              hint: 'Confirm password',
              icon: Icons.lock,
              obscure: true,
              validator: (v) {
                if (v != widget.passwordController.text) {
                  return 'Passwords do not match';
                }
                // else if (widget.passwordController.text.isEmpty) {
                //   return 'This field cannot be empty';
                // }
                else {
                  return null;
                }
              },
              width: ref.watch(devicesizeX),
            ),
            Row(
              //i put the row on top just to center it like other feild in this page
              children: [
                SizedBox(
                  width: 0.9 * ref.watch(devicesizeX).w,
                  child: TextFormField(
                    autofocus: true,
                    controller: _otpController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'otp is required';
                      } else if (v != ref.read(otpValue).toString()) {
                        ref.read(onButtonPressed.notifier).state = false;
                        return 'Invalid OTP';
                      } else if (v == ref.read(otpValue).toString()) {
                        ref.read(otpStatus.notifier).state = 'Email confirmed';

                        return null;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      suffix: ElevatedButton(
                        onPressed: () async {
                          ref.read(onButtonPressed.notifier).state = true;
                          if (ref.read(otpGotten) == false) {
                            await ref
                                .read(otp.future)
                                .timeout(
                                  Duration(seconds: 10),
                                  onTimeout: () {
                                    ref.read(onButtonPressed.notifier).state =
                                        false;
                                    ref.read(otpStatus.notifier).state =
                                        'Failed to send OTP, please try again';
                                    return {
                                      'opt': 0,
                                      'message':
                                          'Failed to send OTP, please try again',
                                    };
                                  },
                                );
                            print(ref.read(otpStatus));
                            if (ref.read(otpValue) != 0) {
                              ref.read(otpGotten.notifier).state = true;
                            }
                          }
                        },
                        child: Text(
                          ref.read(onButtonPressed) && widget.isactive
                              ? 'Otp Sent'
                              : 'Send Otp',
                        ),
                      ),
                      hintText: 'Email Confirmation OTP',
                    ),
                  ),
                ),
              ],
            ),
            //noticed that when the user have zero internt access, the loading bar just stuck, fix with fureBuilder
            ref.watch(onButtonPressed) &&
                    widget.isactive &&
                    !ref.watch(otpGotten)
                ? Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: ref.watch(devicesizeX) * 0.4.w,
                      vertical: 20,
                    ),
                    child: LinearProgressIndicator(),
                  )
                : SizedBox(),

            ref.watch(otpGotten)
                ? Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: 0.09 * ref.read(devicesizeX).h,
                          ),
                          child: Text(
                            ref.watch(otpStatus),
                            style: TextStyle(
                              color:
                                  ref.read(otpStatus.notifier).state ==
                                      'Email confirmed'
                                  ? mainColor
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 0.09 * ref.read(devicesizeX).h,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              widget.formController?.currentState?.validate();
                            },
                            child: Text('Confirm email'),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class Reg4 extends ConsumerStatefulWidget {
  final formController;
  final isactive;

  const Reg4({super.key, this.formController, this.isactive});

  @override
  ConsumerState<Reg4> createState() => _Reg4State();
}

class _Reg4State extends ConsumerState<Reg4> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formController,
      child: Container(
        width: ref.watch(devicesizeX).w,
        height: ref.watch(devicesizeY).h,
        color: Colors.white,
        child: Column(
          children: [
            Text("""
BY CLICKING NEXT, YOU AGREE TO OUR TERMS OF USAGE AND AUTHORIZE THE CREATION OF AN ACCOUNT WITH YOUR PROVIDED DETAILS ON OUR SERVER
FOR RECONFIMATION, PLEASE RECHECK THE DATA BELOW AND MAKE SURE THEY ARE ACCURATE AS THIS INFORMATION IS CRUCIAL FOR ACCESSING YOUR ACCOUNT



Full Name -> 
\t${ref.read(userSurname).toUpperCase()} ${ref.read(userFirstname).toUpperCase()}

Email Address -> 
\t${ref.read(userEmail).toUpperCase()}


""", style: TextStyle(fontWeight: FontWeight.bold)),
            Text('...', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

Widget _field({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  required double width,
  TextInputType keyboard = TextInputType.text,
  bool obscure = false,
  String? Function(String?)? validator,
}) {
  //i used the row to force it to start from the LHS
  return Row(
    children: [
      SizedBox(
        width: 0.9 * width.w,
        child: TextFormField(
          keyboardType: keyboard,
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            focusColor: Color(0xFFFFA001),

            hintText: hint,
            prefixIcon: Icon(icon),
          ),
        ),
      ),
    ],
  );
}

final otpGotten = StateProvider<bool>((ref) {
  return false;
});
final onButtonPressed = StateProvider<bool>((ref) {
  return false;
});

final reg1StartSpinning = StateProvider<bool>((ref) {
  return false;
});
