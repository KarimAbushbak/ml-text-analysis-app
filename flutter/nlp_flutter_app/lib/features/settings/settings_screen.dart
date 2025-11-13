import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/theme_provider.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(AppStrings.darkMode),
            subtitle: const Text(AppStrings.toggleDarkTheme),
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.about),
            subtitle: Text('${AppStrings.appName} ${AppStrings.appVersion}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(AppStrings.aboutLinguaSense),
                  content: Text(
                    '${AppStrings.appDescription}\n\n'
                    '${AppStrings.features}:\n'
                    '${AppStrings.featureSentimentAnalysis}\n'
                    '${AppStrings.featureTranslation}\n'
                    '${AppStrings.featureParaphrasing}\n'
                    '${AppStrings.featureNER}\n'
                    '${AppStrings.featureSummarization}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppStrings.close),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

