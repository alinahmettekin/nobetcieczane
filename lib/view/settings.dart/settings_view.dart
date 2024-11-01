import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/theme/theme_provider.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.settings_app_bar.tr(),
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.theme_mode.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) async {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.language_text.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () async {
                        String locale = EasyLocalization.of(context)!.locale.toString();
                        if (locale == 'tr_TR') {
                          context.setLocale(const Locale('en', 'US'));
                        } else {
                          context.setLocale(const Locale('tr', 'TR'));
                        }
                      },
                      icon: EasyLocalization.of(context)!.locale.toString() == 'tr_TR'
                          ? Image.asset(
                              "assets/icon/turkey_icon.png",
                              height: 40,
                            )
                          : Image.asset(
                              "assets/icon/united_kingdom.png",
                              height: 40,
                            ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
