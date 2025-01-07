import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/constants/image_constants.dart';
import 'package:nobetcieczane/core/init/lang/translations/language_manager.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/core/init/theme/cubit/theme_cubit.dart';

/// SettingsView is a StatefulWidget that contains the settings view.
class SettingsView extends StatefulWidget {
  /// SettingsView constructor
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
          LocaleKeys.settings_app_bar_title.tr(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.settings_dark_theme.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    activeColor: Colors.grey,
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) =>
                        context.read<ThemeCubit>().toggleTheme(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.settings_language.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      final locale = EasyLocalization.of(context)!.locale;
                      if (locale == LanguageManager.instance.trLocale) {
                        await context
                            .setLocale(LanguageManager.instance.enLocale);
                      } else {
                        await context
                            .setLocale(LanguageManager.instance.trLocale);
                      }
                    },
                    icon: EasyLocalization.of(context)!.locale ==
                            LanguageManager.instance.trLocale
                        ? Image.asset(
                            ImageConstants.turkiyeIcon,
                            height: 40,
                          )
                        : Image.asset(
                            ImageConstants.ukIcon,
                            height: 40,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
