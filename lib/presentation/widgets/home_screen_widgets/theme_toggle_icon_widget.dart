import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';


class ThemeToggleIconWidget extends StatelessWidget {
  const ThemeToggleIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
      tooltip: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}
