import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/utils/intent_utils.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';
import 'package:nobetcieczane/view/settings.dart/settings_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
            ListTile(
              onTap: () => Navigator.of(context).pop(),
              leading: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text(
                LocaleKeys.drawer_back.tr(),
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            // ListTile(
            //   leading: Icon(Icons.near_me_rounded, color: Theme.of(context).colorScheme.inversePrimary),
            //   title: Text(
            //     LocaleKeys.drawer_duty_pharmacies.tr(),
            //     style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const MapView(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.inversePrimary),
              title: Text(
                LocaleKeys.drawer_settings.tr(),
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: Theme.of(context).colorScheme.inversePrimary),
              title: Text(
                LocaleKeys.drawer_rate_us.tr(),
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onTap: () {
                Navigator.of(context).pop();
                IntentUtils.launchGooglePlay();
              },
            ),
          ],
        ),
      ),
    );
  }
}
