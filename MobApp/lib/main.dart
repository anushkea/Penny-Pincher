import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'dark_light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        // Initialize ThemeProvider with dark mode as default
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDarkMode: true)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: Consumer<AuthService>(
              builder: (context, auth, _) {
                return auth.user == null ? LoginPage() : HomePage();
              },
            ),
          );
        },
      ),
    );
  }
}