import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:sharpbrains/adminPage.dart';
import 'package:sharpbrains/auth/forget_password.dart';
import 'package:sharpbrains/auth/registration.dart';
import 'package:sharpbrains/post-auth/AiChat.dart';
import 'package:sharpbrains/post-auth/homepage.dart';
import 'package:sharpbrains/auth/login_page.dart';
import 'package:sharpbrains/auth/signup_page.dart';
import 'package:sharpbrains/post-auth/settingPages/aiConfig.dart';
import 'package:sharpbrains/post-auth/settingPages/becomeATutor.dart';
import 'package:sharpbrains/post-auth/settingPages/profile.dart';
import 'package:sharpbrains/post-auth/settingPages/referralPage.dart';
import 'package:sharpbrains/post-auth/settingPages/searchTutors.dart';
import 'package:sharpbrains/post-auth/settingPages/seeOurotherApp.dart';
import 'package:sharpbrains/post-auth/settingPages/settingpage.dart';
import 'package:sharpbrains/post-auth/settingPages/testExamAnalysis.dart';
import 'package:sharpbrains/practice-form.dart';
import 'package:sharpbrains/splashscreen.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          Splashscreen(whereToGo: 'login', textToDisplay: '', wait: null),
    ),
    GoRoute(
      path: '/splashscreenToLogInPage',
      builder: (context, state) =>
          Splashscreen(whereToGo: 'login', textToDisplay: '', wait: null),
    ),

    GoRoute(
      path: '/splashscreenPostLogIn',
      builder: (context, state) => Splashscreen(
        whereToGo: 'homepage',
        textToDisplay: 'Verifying Password...',
        wait: true,
      ),
    ),
    GoRoute(
      path: '/splashscreenSignOut',
      builder: (context, state) => Splashscreen(
        whereToGo: 'signup',
        textToDisplay: "It's Not Bye Bye But See You Again",
        wait: null,
      ),
    ),
    GoRoute(
      path: '/splashscreenRegistrationPage',
      builder: (context, state) => Splashscreen(
        whereToGo: 'registration',
        textToDisplay: '',
        wait: true,
      ),
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/registration', builder: (context, state) => Registration()),
    GoRoute(path: '/homepage', builder: (context, state) => const Homepage()),
    GoRoute(path: '/aichat', builder: (context, state) => const AiChat()),
    GoRoute(path: '/practice', builder: (context, state) => const Practice()),
    GoRoute(path: '/SettingPage', builder: (context, state) => SettingPage()),
    GoRoute(path: '/aiconfig', builder: (context, state) => Aiconfig()),
    GoRoute(path: '/adminpage', builder: (context, state) => const Adminpage()),

    GoRoute(
      path: '/Testexamanalysis',
      builder: (context, state) => Testexamanalysis(),
    ),
    GoRoute(path: '/searchtutors', builder: (context, state) => Searchtutors()),
    GoRoute(path: '/becomeatutor', builder: (context, state) => Becomeatutor()),

    GoRoute(
      path: '/Seeourotherapp',
      builder: (context, state) => Seeourotherapp(),
    ),
    GoRoute(path: '/referralpage', builder: (context, state) => Referralpage()),

    GoRoute(
      path: '/SettingProfile',
      builder: (context, state) => SettingProfile(),
    ),
    GoRoute(
      path: '/forgotPassword',
      builder: (context, state) => forgotPassword(),
    ),
  ],
);

GoRouter get routerInstance => _router;

//for the screen size design reference
final devicesizeX = Provider<double>((ref) {
  return 360;
});
final devicesizeY = Provider<double>((ref) {
  return 766;
});

Color mainColor = Color(0xFF4E54C8);

Map<String, IconData> coursesIcon = {'bio': Icons.pending};

int minimumAgetoUseApp = 10;
//must be in small letters cos of some usage in reg page

Map<String, String> coursesSvgIcon = {
  'physics':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="2" fill="currentColor"/>
  
  <ellipse cx="12" cy="12" rx="10" ry="4" transform="rotate(45 12 12)" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  
  <ellipse cx="12" cy="12" rx="10" ry="4" transform="rotate(-45 12 12)" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''',
  'chemistry':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M7.5 3H16.5M10 3V10L4.5 20C3.8 21.3 4.8 23 6.3 23H17.7C19.2 23 20.2 21.3 19.5 20L14 10V3" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M7.5 15.5H16.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  
  <circle cx="10" cy="18.5" r="1" fill="currentColor"/>
  <circle cx="14" cy="17" r="0.5" fill="currentColor"/>
</svg>''',
  'biology':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M8 3C8 3 13 8 13 12C13 16 8 21 8 21" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  
  <path d="M16 3C16 3 11 8 11 12C11 16 16 21 16 21" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  
  <path d="M9.5 7H14.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.6"/>
  <path d="M11 12H13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  <path d="M9.5 17H14.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.6"/>
</svg>''',
  'english':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 21V5C12 5 10 3 6 3C2 3 2 5 2 5V19C2 19 2 17 6 17C10 17 12 19 12 19V21Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M12 21V5C12 5 14 3 18 3C22 3 22 5 22 5V19C22 19 22 17 18 17C14 17 12 19 12 19V21Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M15 8H19" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" opacity="0.4"/>
  <path d="M15 12H19" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" opacity="0.4"/>
</svg>''',
  'computer':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M7 8L3 12L7 16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M17 8L21 12L17 16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M14 4L10 20" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''',
  'mathematics':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="4" y="2" width="16" height="20" rx="2" stroke="currentColor" stroke-width="2"/>
  
  <path d="M7 6H17" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  
  <circle cx="8" cy="11" r="1" fill="currentColor"/>
  <circle cx="12" cy="11" r="1" fill="currentColor"/>
  <circle cx="16" cy="11" r="1" fill="currentColor"/>
  
  <circle cx="8" cy="15" r="1" fill="currentColor"/>
  <circle cx="12" cy="15" r="1" fill="currentColor"/>
  <circle cx="16" cy="15" r="1" fill="currentColor"/>
  
  <path d="M8 19H16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''',
  'art':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2C6.48 2 2 6.48 2 12C2 17.52 6.48 22 12 22C13.5 22 14.5 21 14.5 19.5C14.5 18.8 14.2 18.2 13.8 17.7C13.7 17.6 13.6 17.4 13.6 17.3C13.6 17 13.9 16.7 14.2 16.7H16C19.3 16.7 22 14 22 10.7C22 5.9 17.5 2 12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <circle cx="7.5" cy="10.5" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="7.5" r="1.5" fill="currentColor"/>
  <circle cx="16.5" cy="10.5" r="1.5" fill="currentColor"/>
</svg>''',
  'economics':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 3V21H21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M18 9L13 14L10 11L6 15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M18 5V9H14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''',
  'law':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M14 7L10 11M14 7L17 4L20 7L17 10L14 7ZM10 11L7 14L4 11L7 8L10 11Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M10 11L3 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M7 21H17" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>''',
  'geography':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
  
  <path d="M2 12H22" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
  
  <path d="M12 2C14.5 4.5 16 8 16 12C16 16 14.5 19.5 12 22C9.5 19.5 8 16 8 12C8 8 9.5 4.5 12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''',
  'history':
      '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M4 6C4 4.9 4.9 4 6 4H18C19.1 4 20 4.9 20 6C20 7.1 19.1 8 18 8H6C4.9 8 4 7.1 4 6Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
  
  <path d="M20 6V18C20 19.1 19.1 20 18 20H6C4.9 20 4 19.1 4 18V6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <path d="M8 12H16" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.5"/>
  <path d="M8 16H13" stroke="currentColor" stroke-width="2" stroke-linecap="round" opacity="0.5"/>
</svg>''',
};

Map<String, List<String>> homepageVerticalIcons = {
  'CGPA calc': [''],
  'Take Exam': [''],
  'Tutuor': [''],
  'Competition': [''],
  'Analysis': [''],
};

List<String> aspirantOrLevel = [
  'aspirant',
  '100L',
  '200L',
  '300L',
  '400L',
  '500L',
];
Map<String, List<int>> monthLenght = {
  'jan': List.generate(31, (index) => index + 1),
  'feb': List.generate(28, (index) => index + 1),
  'mar': List.generate(31, (index) => index + 1),
  'april': List.generate(30, (index) => index + 1),
  'june': List.generate(30, (index) => index + 1),
  'july': List.generate(31, (index) => index + 1),
  'aug': List.generate(31, (index) => index + 1),
  'sep': List.generate(30, (index) => index + 1),
  'oct': List.generate(31, (index) => index + 1),
  'nov': List.generate(30, (index) => index + 1),
  'dec': List.generate(31, (index) => index + 1),
};
void notifier({
  required BuildContext context,
  required Duration? duration,
  required Color bg,
  required String text,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration ?? Duration(seconds: 2),

      content: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: (766 * 0.1).h),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: bg,

            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      // width: 0.2 * ref.read(devicesizeX),
      backgroundColor: Colors.transparent,

      elevation: 0,
    ),
  );
}

final userAITempChatHolder = StateProvider<Map<String, List<String>>>((ref) {
  return {'user': [], 'AI': []};
});

final universityNameSaved = FutureProvider((ref) async {
  final url = Uri.parse('${ref.read(backendUrl)}universities_name/');
  final response = await http.get(url);
  final List temp = jsonDecode(response.body);
  final uniNames = temp.map((items) => items as Map<String, dynamic>).toList();

  if (response.statusCode == 200) {
    return uniNames;
  }
  //  else {
  //   return [
  //     //since GET ony respond 200 as a good to go, everything else is useless
  //     {'name_of_universities': 'invalid'},
  //   ];
  // }
});

final coursesOfferedSaved = FutureProvider<List<Map<String, dynamic>>?>((
  ref,
) async {
  final url = Uri.parse('${ref.read(backendUrl)}course_names/');
  final response = await http.get(url);
  final List temp = jsonDecode(response.body);
  final courses = temp.map((items) => items as Map<String, dynamic>).toList();

  if (response.statusCode == 200) {
    return courses;
  } else {
    return [
      {
        'id': 'NULL',
        'name_of_uni': 'INVALID',
        'courses_offered': [''],
      },
    ];
  }
});

final jambSubjectCombinationSaved = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final url = Uri.parse('${ref.read(backendUrl)}jamb_subject_combination/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List temp = await jsonDecode(response.body);
    return temp.map((items) => items as Map<String, dynamic>).toList();
    //forcing it to return a list<Map<String, dynamic>> by force by fire
  } else {
    return [
      {
        "uni_name": "INVALID",
        "course_name": "",
        "core_subjects": [""],
        "subject_combination": [""],
      },
    ];
  }
});

final aiChatResponse = FutureProvider.family((
  ref,
  Map userResponseAndAiName,
) async {
  try {
    final url = Uri.parse('${ref.read(backendUrl)}aichat/');
    final post = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },

      body: jsonEncode({
        'ai_name': userResponseAndAiName['ai_name'],
        'message': userResponseAndAiName['message'],
        'history': ref.read(
          userAITempChatHolder,
        ), //,work in progress, this is supposed to send the chat history to the backend so that the ai can use it to generate a more contextually relevant response, but im not sure if im doing it right, ill have to test it out and see if it works, if it doesnt work then ill have to figure out how to properly send the chat history to the backend, maybe i need to convert it to a different format or something, ill have to do some research and see how other people are doing it and try to implement it in a similar way. hopefully it works on the first try tho, that would be nice.
      }),
    );
    if (post.statusCode > 199 && post.statusCode < 300) {
      final response = await jsonDecode(post.body);
      return response;
    }
    return {
      'ai_response': post.statusCode == 404
          ? "You are offline.\nPlease check your internet connection and try again"
          : 'Something went wrong but dont worry, its not you, its us.\nPlease try again later',
      'token': 999999,
      'code': post.statusCode,
    };
  } catch (e) {
    return {
      'ai_response':
          "An error occurred while processing your request.\n\ERROR : $e",
      'token': 999999,
      'code': 500,
    };
  }
});

final aiNameHolder = StateProvider((ref) {
  return 'Tis';
});

final aiNavBarContent = StateProvider<List<List>>((ref) {
  return [
    [
      'Clear Chat History',
      () {
        ref.invalidate(userAITempChatHolder);
      },
    ],
    [
      'Ai Configuration',
      () {
        return routerInstance.push('/aiconfig');
      },
    ],
  ];
});

final otp = FutureProvider((ref) async {
  final url = Uri.parse('${ref.read(backendUrl)}otp/');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': ref.read(userEmail),
        'surname': ref.read(userSurname),
        'firstname': ref.read(userFirstname),
      }),
    );
    final data = await jsonDecode(response.body);
    if (response.statusCode == 200) {
      ref.read(otpStatus.notifier).state = data['message'];
      ref.read(otpValue.notifier).state = data['otp'];
      return data;
    } else {
      ref.read(otpStatus.notifier).state =
          'Something went wrong but dont worry, its not you, its us.\nPlease try again';
      return {
        'otp': 0,
        'message':
            'Something went wrong but dont worry, its not you, its us.\nPlease try again',
      };
    }
  } catch (e) {
    ref.read(otpStatus.notifier).state =
        'Something went wrong but dont worry, its not you, its us.\nPlease try again';
    return {
      'otp': 0,
      'message':
          'Something went wrong but dont worry, its not you, its us.\nPlease try again',
    };
  }
});
final otpStatus = StateProvider((ref) => '');
final otpValue = StateProvider((ref) => 0);

//BASIC INFO PAGE
final userSurname = StateProvider((ref) => '');
final userFirstname = StateProvider((ref) => '');
final userEmail = StateProvider((ref) => '');
final userYearOfBirth = StateProvider((ref) => '');
final userMonthOfBirth = StateProvider((ref) => '');
final userDateOfBirth = StateProvider((ref) => '');
//EDUCATION DETAILS PAGE
final userUniversityName = StateProvider((ref) => '');
final userDeptOfStudy = StateProvider((ref) => '');
final userLevel = StateProvider((ref) => '');
//SECURITY PAGE
final userPassword = StateProvider((ref) => '');

//data to send to backend for registration
final formSubmission = FutureProvider((ref) async {
  final url = Uri.parse("${ref.read(backendUrl)}signup/");
  final data = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "surname": ref.read(userSurname),
      "first_name": ref.read(userFirstname),
      "email": ref.read(userEmail),
      "yearOfBirth": ref.read(userYearOfBirth),
      "monthOfBirth": ref.read(userMonthOfBirth),
      "dateOfBirth": ref.read(userDateOfBirth),
      "Universities_name": ref.read(userUniversityName),
      "dept_name": ref.read(userDeptOfStudy),
      "level": ref.read(userLevel),
      "password": ref.read(userPassword),
    }),
  );
  print(data.statusCode);
  if (data.statusCode == 200) {
    final response = await jsonDecode(data.body);
    return response;
  }
});

final userLoginCheck = FutureProvider.family((ref, Map userDetails) async {
  final url = Uri.parse("${ref.read(backendUrl)}signup/").replace(
    queryParameters: {
      "email": userDetails["email"],
      "password": userDetails["password"],
    },
  );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = await jsonDecode(response.body);

    return data; //a dictionary
  } else {
    return {
      "message": "app error",
      "yearOfBirth": 0,
      "monthOfBirth": null,
      "dateOfBirth": null,
      "Universities_name": "invalid",
      "dept_name": "invalid",
      "level": "invalid",
    };
  }
});

final materials = FutureProvider.family((ref, String text) async {
  //i am sure i will still edit this later using the dio that this guy said so i cannot rewlly write code for this one now
  // try {
  //   final url = Uri.parse("${ref.read((backendUrl))}/material/");
  //   final urlWithQuery = url.replace(queryParameters: {"file_name": text});
  //   final response = await http.get(urlWithQuery);
  //   if (response.statusCode == 200) {
  //     final data = await jsonDecode(response.body);
  //     return data;
  //   }
  //   return null;
  // } catch (e) {
  //   return e.toString();
  // }
});

final CoursesForEachDept = FutureProvider.family((
  ref,
  Map uniAndDeptName,
) async {
  final url = Uri.parse("${ref.read(backendUrl)}/courses_for_each_dept/")
      .replace(
        queryParameters: {
          "uni_name": uniAndDeptName["uni_name"],
          "dept_name": uniAndDeptName["dept_name"],
        },
      );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = await jsonDecode(response.body);
    return data;
  }
  return {
    "dept_name": "invalid",
    "uni_name": "Invalid",
    "first_semester": [],
    "second_semester": [],
  };
});
final CoursesForEachDeptSaved = StateProvider<Map<String, dynamic>>((ref) {
  return {
    "uni_name": "invalid",
    "dept_name": "invalid",
    "first_semester": ["invalid"],
    "second_semester": [],
  };
});
final currentSemesterTracker = StateProvider<String>((ref) {
  return "first"; //or second
});
