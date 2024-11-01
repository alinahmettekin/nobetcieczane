import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/utils/intent_utils.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';

class CustomPhoneCallButton extends StatelessWidget {
  final String phone;
  const CustomPhoneCallButton({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        IntentUtils.launchPhoneCall(phone);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone),
              const SizedBox(
                width: 10,
              ),
              Text(LocaleKeys.call_button.tr()),
            ],
          ),
        ),
      ),
    );
  }
}
