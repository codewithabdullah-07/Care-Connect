import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/colors.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<String>(
          tooltip: 'Theme',
          icon: const Icon(Icons.brightness_6_outlined, color: AppColors.gold),
          onSelected: provider.setThemeMode,
          itemBuilder: (context) => [
            _item('light', 'Light', Icons.light_mode_outlined, provider.modeName),
            _item('dark', 'Dark', Icons.dark_mode_outlined, provider.modeName),
            _item('system', 'System', Icons.settings_suggest_outlined, provider.modeName),
          ],
        );
      },
    );
  }

  PopupMenuItem<String> _item(String value, String label, IconData icon, String current) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          if (current == value) const Icon(Icons.check, size: 18),
        ],
      ),
    );
  }
}
