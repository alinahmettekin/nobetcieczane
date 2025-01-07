import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nobetcieczane/core/base/entities/city.dart';
import 'package:nobetcieczane/core/base/entities/selectable.dart';
import 'package:nobetcieczane/core/constants/constants.dart';
import 'package:nobetcieczane/core/helper/ad_mob_helper.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/core/init/theme/cubit/theme_cubit.dart';
import 'package:nobetcieczane/core/utils/location.dart';
import 'package:nobetcieczane/features/home/presentation/bloc/home_bloc.dart';
import 'package:nobetcieczane/features/home/presentation/view/map/map_view.dart';
import 'package:nobetcieczane/features/home/presentation/view/pharmacies/pharmacies_view.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/button/location_button.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/button/search_button.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/custom_drawer.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/dropdown/drop_down_menu_builder.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/dropdown/dropdown_list_content.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/recent_searchs.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/selection_card.dart';

part 'mixin/home_view_mixin.dart';

/// HomeView is a StatefulWidget that contains the home view.
class HomeView extends StatefulWidget {
  /// HomeView constructor
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with _HomeViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          Constants.appName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        actions: _appBarActions(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAdMobBanner(),
                  const SizedBox(height: 10),
                  _buildCitySelectionButton(),
                  _buildDistrictSelectionButton(),
                  const SizedBox(height: 10),
                  _buildSearchButton(),
                  const SizedBox(height: 10),
                  _buildRecentSearchs(),
                ],
              ),
            ),
          ),
          _buildLocationButton(),
        ],
      ),
    );
  }

  Widget _buildAdMobBanner() {
    return const SizedBox(
      height: 50, // Daha küçük banner yüksekliği
      width: double.infinity,
      child: AdMobBannerWidget(
        type: BannerAdType.firstBanner,
      ),
    );
  }

  Widget _buildCitySelectionButton() {
    return SelectionButton(
      icon: Icons.location_city,
      title: _selectedCity?.cities ?? LocaleKeys.home_choose_city.tr(),
      subtitle: LocaleKeys.home_look_up_city.tr(),
      onTap: () => _onCitySelect(context),
    );
  }

  Widget _buildDistrictSelectionButton() {
    return SelectionButton(
      icon: Icons.map_outlined,
      title: _selectedDistrict?.cities ?? LocaleKeys.home_choose_district.tr(),
      subtitle: LocaleKeys.home_look_up_district.tr(),
      onTap: () => _selectedCity != null
          ? _onDistrictSelect(context)
          : _showAlert(context, LocaleKeys.snackbar_choose_city.tr()),
    );
  }

  Widget _buildRecentSearchs() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.23,
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) => current is HomeRecentSearchesLoading,
        builder: (context, state) {
          if (state is HomeRecentSearchesLoading) {
            return RecentSearchs(
              searches: state.searches,
              onDeleteItem: (search) {
                context
                    .read<HomeBloc>()
                    .add(HomeDeleteRecentSearch(search: search));
              },
              onClearAll: () {
                context.read<HomeBloc>().add(HomeClearRecentSearches());
              },
              onSearchTap: (search) {
                setState(() {
                  _selectedCity = City(
                    cities: search['cityName']!,
                    slug: search['citySlug']!,
                  );
                  _selectedDistrict = City(
                    cities: search['districtName']!,
                    slug: search['districtSlug']!,
                  );
                });
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
