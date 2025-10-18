import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_notebook/app_theme.dart';
import 'package:order_notebook/screens/welcome_screen.dart';
import 'package:order_notebook/utilities/firebase_options.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(
    const ProviderScope(child: MyApp()),
  );
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

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:order_notebook/app_theme.dart';
// import 'package:order_notebook/map_widget/map_locator.dart';

// /// This widget constrains the app to a fixed portrait-like width for ALL screens
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

// void main() => runApp(const MyApp());

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late GoogleMapController mapController;

//   final LatLng _center = const LatLng(26.873601, 75.776285);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }



//     @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home:MapPickerScreen(),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return MaterialApp(
//   //     home: Scaffold(
//   //       appBar: AppBar(
//   //         title: const Text('Maps Sample App'),
//   //         backgroundColor: Colors.green[700],
//   //       ),
//   //       body: GoogleMap(
//   //         onMapCreated: _onMapCreated,
//   //         initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
//   //       ),
//   //     ),
//   //   );
//   // }
// }
