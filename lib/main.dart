import 'package:bookbuddy/auth/services/auth.dart';
import 'package:bookbuddy/firebase_options.dart';
import 'package:bookbuddy/models/error_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  bool loggedIn = false;
  
  
  // Future<void> _loadTheme() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   isLightTheme = prefs.getBool('isLightTheme') ?? true;
  // }

  @override
  void initState() {
    super.initState();
    getUserData();
    // _loadTheme();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();

    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }



  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user != null && user.id.isNotEmpty) {
      loggedIn = true;
    } else {
      loggedIn = false;
    }
    print(loggedIn);

    bool isLightTheme = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'BookBuddy',
      debugShowCheckedModeBanner: false,
      theme:isLightTheme? ThemeData.dark():
       ThemeData(

        primarySwatch: Colors.blue,
       ),

      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if (user != null && user.id.isNotEmpty) {
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
