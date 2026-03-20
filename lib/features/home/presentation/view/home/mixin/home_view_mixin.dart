part of '../home_view.dart';

mixin _HomeViewMixin on State<HomeView> {
  Selectable? _selectedCity;
  Selectable? _selectedDistrict;
  bool _isLocationLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearchs();
    _checkAppReview();
  }

  void _checkAppReview() {
    unawaited(
      IntentUtils.checkAndRequestReview(serviceLocator.get<CacheService>()),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // WIDGETS

  Widget _buildSearchButton() {
    return SearchButton(
      title: LocaleKeys.home_searh.tr(),
      onTap: _navigateToPharmaciesView,
      icon: Icons.arrow_forward_ios,
    );
  }

  Widget _buildLocationButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 75,
          width: double.infinity,
          child: _isLocationLoading
              ? LocationButton(
                  title: LocaleKeys.location_loading.tr(),
                  onTap: () {}, // disabled while loading
                  isLoading: true,
                )
              : LocationButton(
                  title: LocaleKeys.buttons_location.tr(),
                  onTap: () => navigateToMapView(context),
                ),
        ),
      ),
    );
  }

  List<Widget> _appBarActions() => [];

  // FUNCTIONS

  void _loadRecentSearchs() {
    context.read<HomeBloc>().add(HomeLoadRecentSearches());
  }

  Future<void> _onCitySelect(BuildContext context) async {
    context.read<HomeBloc>().add(HomeGetCities());
    final selectedCity = await showDropdownListMenu(
      context,
      title: LocaleKeys.home_choose_city.tr(),
      itemsSelector: (state) => state is HomeGetCitiesSuccess ? state.cities : null,
    );
    if (selectedCity != null) {
      setState(() {
        _selectedCity = selectedCity;
        _selectedDistrict = null; // Şehir değişince ilçe sıfırlanır
      });
    }
  }

  Future<void> _onDistrictSelect(BuildContext context) async {
    context.read<HomeBloc>().add(HomeGetDistricts(citySlug: _selectedCity!.slug));
    final selectedDistrict = await showDropdownListMenu(
      context,
      title: LocaleKeys.home_choose_district.tr(),
      itemsSelector: (state) => state is HomeGetDistrictsSuccess ? state.districts : null,
    );
    if (selectedDistrict != null) {
      setState(() {
        _selectedDistrict = selectedDistrict;
      });
    }
  }

  // NAVIGATIONS

  void _navigateToPharmaciesView() {
    if (_selectedCity != null && _selectedDistrict != null) {
      context.read<HomeBloc>().add(
            HomeSaveRecentSearch(
              cityName: _selectedCity!.cities,
              citySlug: _selectedCity!.slug,
              districtName: _selectedDistrict!.cities,
              districtSlug: _selectedDistrict!.slug,
            ),
          );
      context.read<HomeBloc>().add(
            HomeGetPharmacies(
              citySlug: _selectedCity!.slug,
              districtSlug: _selectedDistrict!.slug,
            ),
          );
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (context) => PharmaciesView(
            city: _selectedCity!.cities,
            district: _selectedDistrict!.cities,
          ),
        ),
      );
    } else {
      _showAlert(context, LocaleKeys.snackbar_choose_city_district.tr());
    }
  }

  Future<void> navigateToMapView(BuildContext context) async {
    // Show loading indicator on the button
    setState(() => _isLocationLoading = true);

    final result = await getUserLocation();

    setState(() => _isLocationLoading = false);

    if (!context.mounted) return;

    switch (result.status) {
      case LocationResultStatus.granted:
        final data = result.data!;
        context.read<HomeBloc>().add(
              HomeGetNearPharmacies(
                latitude: data.latitude!,
                longitude: data.longitude!,
              ),
            );
        unawaited(
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapView(
                latitude: data.latitude!,
                longitude: data.longitude!,
              ),
            ),
          ),
        );

      case LocationResultStatus.denied:
        await _showLocationDialog(
          context,
          title: LocaleKeys.location_dialog_denied_title.tr(),
          message: LocaleKeys.location_dialog_denied_message.tr(),
          primaryLabel: LocaleKeys.location_button_grant.tr(),
          onPrimary: () {
            Navigator.pop(context);
            // Re-trigger after user reads the explanation
            unawaited(navigateToMapView(context));
          },
        );

      case LocationResultStatus.deniedForever:
        await _showLocationDialog(
          context,
          title: LocaleKeys.location_dialog_denied_forever_title.tr(),
          message: LocaleKeys.location_dialog_denied_forever_message.tr(),
          primaryLabel: LocaleKeys.location_button_go_to_settings.tr(),
          onPrimary: () async {
            Navigator.pop(context);
            // Opens system app-settings page on both iOS and Android
            await Location().requestPermission();
          },
        );

      case LocationResultStatus.serviceDisabled:
        await _showLocationDialog(
          context,
          title: LocaleKeys.location_dialog_service_disabled_title.tr(),
          message: LocaleKeys.location_dialog_service_disabled_message.tr(),
          primaryLabel: LocaleKeys.location_button_go_to_settings.tr(),
          onPrimary: () async {
            Navigator.pop(context);
            await Location().requestService();
          },
        );
    }
  }

  Future<void> _showLocationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String primaryLabel,
    required VoidCallback onPrimary,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.location_button_cancel.tr()),
          ),
          FilledButton(
            onPressed: onPrimary,
            child: Text(primaryLabel),
          ),
        ],
      ),
    );
  }

  // ALERTS

  void _showAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

// Widget building utilities

// Main function with proper generic type constraint
Future<T?> showDropdownListMenu<T extends Selectable>(
  BuildContext context, {
  required List<T>? Function(HomeState state) itemsSelector,
  String? title,
}) async {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return BlocConsumer<HomeBloc, HomeState>(
        listener: _handleFailureStates,
        builder: (context, state) {
          if (state is HomeLoading) {
            return DropdownMenuBuilder.buildLoadingState();
          }

          if (state is HomeGetCitiesSuccess || state is HomeGetDistrictsSuccess) {
            final items = itemsSelector(state);
            return DropdownListContent<T>(
              items: items,
              title: title,
              isDarkMode: isDarkMode,
              onItemSelected: (item) => Navigator.pop(context, item),
            );
          }

          return DropdownMenuBuilder.buildEmptyState();
        },
      );
    },
  );
}

void _handleFailureStates(BuildContext context, HomeState state) {
  if (state is HomeGetCitiesFailure || state is HomeGetDistrictsFailure) {
    final message = state is HomeGetCitiesFailure ? state.message : (state as HomeGetDistrictsFailure).message;

    Navigator.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}
