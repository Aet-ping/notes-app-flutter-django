import 'package:flutter/material.dart';
import 'package:ui_notes_app/routes/auth/login.dart';
import 'package:json_theme_plus/json_theme_plus.dart';
import 'package:ui_notes_app/services/notes_data.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:ui_notes_app/routes/notes/notes_part.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the theme from the JSON file
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(
    theme: theme,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme, // Apply the custom theme
      routes: {
        '/': (context) => AuthenticationWrapper(), // Default route
        '/login': (context) => Login(), // Login screen route
        '/notes': (context) => NotesPart(), // Notes screen route
      },
      initialRoute: '/',
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAndAuthenticate(), // Check if the user is authenticated
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          // If authenticated, navigate to the Notes screen
          return NotesPart();
        } else {
          // If not authenticated, navigate to the Login screen
          return Login();
        }
      },
    );
  }
}
