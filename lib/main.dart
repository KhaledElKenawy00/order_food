import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2/provider/user_provider.dart';
import 'package:task2/views/welcome_screen.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calorie Calculator',
        home: const WelcomeScreen(),
      ),
    );
  }
}
