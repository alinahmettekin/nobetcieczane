import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/base/entities/pharmacy.dart';
import 'package:nobetcieczane/core/helper/ad_mob_helper.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/features/home/presentation/bloc/home_bloc.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/custom_pharmacy_card.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/loader.dart';

/// PharmaciesView is a StatelessWidget that contains the pharmacies view.
class PharmaciesView extends StatelessWidget {
  /// PharmaciesView constructor
  const PharmaciesView({
    required this.city,
    required this.district,
    super.key,
  });

  /// city is using for city name on the app bar
  final String city;

  /// district is using for district name on the app bar
  final String district;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '$city - $district',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeGetPharmaciesSuccess) {
                if (state.pharmacies.isEmpty) {
                  return Center(
                    child: Text(
                      LocaleKeys.no_duty_pharmacies.tr(),
                      style: const TextStyle(),
                    ),
                  );
                }
                final pharmacies = state.pharmacies;
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildPharmacies(pharmacies),
                );
              } else if (state is HomeGetPharmaciesFailure) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const Center(child: Loader());
              }
            },
          ),
          _buildAdMobBanner(),
        ],
      ),
    );
  }

  ListView _buildPharmacies(List<Pharmacy> pharmacies) {
    return ListView.builder(
      itemCount: pharmacies.length + 1,
      itemBuilder: (context, index) {
        if (index == pharmacies.length) {
          return const SizedBox(height: 60);
        }
        final pharmacy = pharmacies[index];
        return CustomPharmacyCard(pharmacy: pharmacy);
      },
    );
  }

  Widget _buildAdMobBanner() {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: 2,
      child: AdMobBannerWidget(
        type: BannerAdType.secondBanner,
      ),
    );
  }
}
