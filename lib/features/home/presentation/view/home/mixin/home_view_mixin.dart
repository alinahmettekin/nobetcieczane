part of '../home_view.dart';

mixin _HomeViewMixin on State<HomeView> {
  Selectable? _selectedCity;
  Selectable? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    _loadRecentSearchs();
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
          child: LocationButton(
            title: LocaleKeys.buttons_location.tr(),
            onTap: () => navigateToMapView(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return <Widget>[
      IconButton(
        onPressed: () {
          context.read<ThemeCubit>().toggleTheme();
          setState(() {});
        },
        icon: context.read<ThemeCubit>().state.theme == AppTheme.light
            ? const Icon(Icons.dark_mode)
            : const Icon(Icons.light_mode),
      ),
    ];
  }

  // FUNCTIONS

  void _loadRecentSearchs() {
    context.read<HomeBloc>().add(HomeLoadRecentSearches());
  }

  Future<void> _onCitySelect(BuildContext context) async {
    context.read<HomeBloc>().add(HomeGetCities());
    final selectedCity = await showDropdownListMenu(
      context,
      title: LocaleKeys.home_choose_city.tr(),
      itemsSelector: (state) =>
          state is HomeGetCitiesSuccess ? state.cities : null,
    );
    if (selectedCity != null) {
      setState(() {
        _selectedCity = selectedCity;
        _selectedDistrict = null; // Şehir değişince ilçe sıfırlanır
      });
    }
  }

  Future<void> _onDistrictSelect(BuildContext context) async {
    context
        .read<HomeBloc>()
        .add(HomeGetDistricts(citySlug: _selectedCity!.slug));
    final selectedDistrict = await showDropdownListMenu(
      context,
      title: LocaleKeys.home_choose_district.tr(),
      itemsSelector: (state) =>
          state is HomeGetDistrictsSuccess ? state.districts : null,
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
    final userLocation = await getUserLocation();

    if (userLocation == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.snackbar_require_location_permission.tr(),
            ),
          ),
        );
      }
      return;
    }

    if (context.mounted) {
      context.read<HomeBloc>().add(
            HomeGetNearPharmacies(
              latitude: userLocation.latitude!,
              longitude: userLocation.longitude!,
            ),
          );
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapView(
              latitude: userLocation.latitude!,
              longitude: userLocation.longitude!,
            ),
          ),
        ),
      );
    }
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

          if (state is HomeGetCitiesSuccess ||
              state is HomeGetDistrictsSuccess) {
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
    final message = state is HomeGetCitiesFailure
        ? state.message
        : (state as HomeGetDistrictsFailure).message;

    Navigator.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}
