/// [Selectable] is an abstract class that is used to create a selectable object
/// for city and district.
abstract class Selectable {
  /// constructor for [Selectable]
  Selectable({
    required this.cities,
    required this.slug,
  });

  /// Name of the city
  final String cities;

  /// Slug of the city
  final String slug;
}
