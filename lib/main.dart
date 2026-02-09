// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:book_stash/auth/ui/sign_up_screen.dart';
import 'package:book_stash/firebase_options.dart';
import 'package:book_stash/auth/ui/login_screen.dart';
import 'package:book_stash/pages/home.dart';
import 'package:book_stash/pages/message_screen.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _fireBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("A notification found in background");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initialize firebase messaging
  await PushNotificationHelper.init();
  // initialize local notifications
  await PushNotificationHelper.localNotificationInitialization();
  FirebaseMessaging.onBackgroundMessage(_fireBackgroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Background notification tapped!');
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    }
  });

  // foreground notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadContent = jsonEncode(message.data);
    print('Message found in background');
    if (message.notification != null) {
      PushNotificationHelper.showLocalNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: payloadContent, 
      );
    }
  });

  // for handling terminated state
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("From terminated state");
    Future.delayed(const Duration(seconds: 3), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        "/": (context) => const CheckUserBookStash(),
        "/login": (context) => const LoginView(),
        "/home": (context) => const HomeView(),
        "/signup": (context) => const SignUpView(),
        "/message": (context) => const MessageScreen(),
      },
    );
  }
}

class CheckUserBookStash extends StatefulWidget {
  const CheckUserBookStash({super.key});

  @override
  State<CheckUserBookStash> createState() => _CheckUserBookStashState();
}

class _CheckUserBookStashState extends State<CheckUserBookStash> {
  @override
  void initState() {
    AuthServiceHelper.isUserLoggedIn().then((value) {
      if (value == true) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
