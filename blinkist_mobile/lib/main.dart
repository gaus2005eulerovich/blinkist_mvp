import 'package:flutter/cupertino.dart';
import 'screens/BookListScreen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const BlinkistCloneApp());
}

class BlinkistCloneApp extends StatelessWidget {
  const BlinkistCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Blinkist Clone',
      theme: AppTheme.mainTheme,
      home: BookListScreen(),
    );
  }
}



