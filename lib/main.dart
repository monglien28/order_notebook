import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_notebook/app_theme.dart';
import 'package:order_notebook/screens/welcome_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: notebookTheme,
      title: 'Order Notebook',
      home: const AppContainer(child: WelcomeScreen()),
    );
  }
}


class AppContainer extends StatelessWidget {
  final Widget child;
  const AppContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double appWidth = 420; // lock to a portrait width
        return Container(
          color: kBeigePrimary, // background space
          alignment: Alignment.center,
          child: SizedBox(width: appWidth, child: child),
        );
      },
    );
  }
}


