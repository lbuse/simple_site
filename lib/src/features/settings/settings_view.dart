import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = GetIt.I.get<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Tema do sistema'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Tema claro'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Tema escuro'),
                )
              ],
              decoration: const InputDecoration(
                labelText: 'Tema',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
