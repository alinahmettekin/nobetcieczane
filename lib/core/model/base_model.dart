abstract class BaseModel<T> {
  Map<String, dynamic> toJSon();
  T fromJson(Map<String, dynamic> json);
}
