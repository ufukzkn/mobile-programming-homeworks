import 'package:flutter/material.dart';

import 'screens/explore_screen.dart';
import 'theme.dart';

void main() => runApp(const CampusApp());

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Campus · Event Explorer',
    debugShowCheckedModeBanner: false,
    theme: campusTheme,
    home: const ExploreScreen(),
  );
}
