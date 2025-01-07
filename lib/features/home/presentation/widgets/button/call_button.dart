import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/core/init/theme/cubit/light/color_scheme_light.dart';
import 'package:nobetcieczane/core/utils/intent_utils.dart';

/// CallButton is a StatelessWidget that contains the call button.
class CallButton extends StatelessWidget {
  /// CallButton constructor
  const CallButton({required this.phoneNumber, super.key});

  /// phoneNumber is a final variable of type String
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        IntentUtils.launchPhoneCall(phoneNumber);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: ColorSchemeLight.instance.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 10),
              Text(
                LocaleKeys.buttons_call.tr(),
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
