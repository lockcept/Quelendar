import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/preference_provider.dart';
import 'package:quelendar/util/card_table.dart';

class SettingBody extends StatelessWidget {
  const SettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final preferenceProvider = context.watch<PreferenceProvider>();
    final isDarkMode = preferenceProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: const Text("설정"),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          CardTable(
            data: {
              '다크모드': Switch(
                value: isDarkMode,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (bool value) {
                  preferenceProvider.setDarkMode(value);
                },
              ),
            },
          ),
        ]),
      ),
    );
  }
}
