import 'package:eczanemnerede/core/model/base_model.dart';

class Cities extends BaseModel<Cities> {
  String? cities;
  String? slug;

  Cities({this.cities, this.slug});

  Cities.fromJson(Map<String, dynamic> json) {
    cities = json["cities"];
    slug = json["slug"];
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  Cities fromJson(Map<String, dynamic> json) {
    return Cities.fromJson(json);
  }

  @override
  Map<String, dynamic> toJSon() {
    throw UnimplementedError();
  }
}
