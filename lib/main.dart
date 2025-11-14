import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/di/di.dart' as di;
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/doc_app.dart';
import 'package:diagno_bot/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await testFirestore();
  await di.init();
  await AuthManager().init();
  runApp(DocApp(appRouter: AppRouter()));
}

Future<void> testFirestore() async {
  // try {
  //   await FirebaseFirestore.instance
  //       .collection('test_collection')
  //       .doc('test_doc')
  //       .set({'message': 'Hello Firebase!'});
  //   print('Firestore is working!');
  // } catch (e) {
  //   print('Error: $e');
  // }
}
