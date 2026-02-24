// import 'dart:convert' show jsonDecode;

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

// // Future<void> post() {
// //   // final url = Uri.parse(
// //   //   'https://esta-sensate-unquickly.ngrok-free.dev/universities_name/',
// //   // );
// //   // final response = http.post(
// //   //   url,
// //   //   headers: {'Content-Type': 'application/json'},
// //   //   body: jsonEncode({'name_of_universities': 'Delete Later'}),
// //   // );

// // }

// class BackendDoor {
//   String urlBackend = 'https://esta-sensate-unquickly.ngrok-free.dev/';

//   Future<List> namesOfUniversitiesGet() async {
//     try {
//       final url = Uri.parse('${urlBackend}universities_name/');
//       final response = await http.get(url);
//       // print(response.body);//incase the error is 503 and it returns html istead of json
//       if (response.statusCode == 200) {
//         final uniNames = jsonDecode(response.body);
//         return uniNames;
//       } else {
//         return [
//           //since GET ony respond 200 as a good to go, everything else is useless
//           {'name_of_universities': 'invalid'},
//         ];
//       }
//     } catch (e) {
//       final uniNames = [
//         {'name_of_universities': e.toString()},
//       ]; // {'name_of_universities': 'Error dectected'};
//       return uniNames;
//     }
//   }

//   Future<List> courseOffered() async {
//     final url = Uri.parse('${urlBackend}course_names/');
//     final response = await http.get(url);
//     try {
//       if (response.statusCode == 200) {
//         final courses = jsonDecode(response.body);
//         // print(courses);
//         return courses;
//       } else {
//         final courses = [
//           {
//             'id': 'null',
//             'name_of_uni': 'invalid',
//             'courses_offered': ['null'],
//           },
//         ];
//         // print(courses);
//         return courses;
//       }
//     } catch (e) {
//       final courses = [
//         {
//           'id': 'null',
//           'name_of_uni': 'invalid',
//           'courses_offered': ['$e'],
//         },
//       ];
//       return courses;
//     }
//   }
// }
