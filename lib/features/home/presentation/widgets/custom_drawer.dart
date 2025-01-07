import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/constants/constants.dart';
import 'package:nobetcieczane/core/constants/image_constants.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/core/init/theme/cubit/light/color_scheme_light.dart';
import 'package:nobetcieczane/core/utils/intent_utils.dart';
import 'package:nobetcieczane/features/home/presentation/view/settings/settings_view.dart';

/// CustomDrawer is a StatelessWidget that contains the custom drawer.
class CustomDrawer extends StatelessWidget {
  /// CustomDrawer constructor
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          ListTile(
            onTap: () => Navigator.of(context).pop(),
            leading: const Icon(
              Icons.arrow_back,
            ),
            title: Text(
              LocaleKeys.drawer_back.tr(),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              LocaleKeys.drawer_settings.tr(),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.star,
            ),
            title: Text(
              LocaleKeys.drawer_rate_us.tr(),
            ),
            onTap: () {
              Navigator.of(context).pop();
              IntentUtils.launchGooglePlay();
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Image.asset(
                  ImageConstants.appLogo,
                  width: 100,
                  height: 100,
                  color: ColorSchemeLight.instance.red,
                ),
                const Text(
                  Constants.developer,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
