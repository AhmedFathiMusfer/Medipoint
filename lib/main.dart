import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/di/di.dart' as di;
import 'package:diagno_bot/core/routing/app_router.dart';
import 'package:diagno_bot/doc_app.dart';
import 'package:diagno_bot/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Stripe
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      'pk_test_51QpdPwBgmAvGuQnxC2gZl1aESH3myJb17u1PBIftdQWw5AXCUp4BMYl0ZEs8Ii5JXqrYlA38FZlaj9daO1HvGxnE00PJyZNSqS';

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
