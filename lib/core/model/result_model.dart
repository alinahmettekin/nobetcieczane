import 'base_model.dart';

class Result extends BaseModel<Result> {
  String? status;
  String? message;
  String? messageTr;
  int? systemTime;
  String? endpoint;
  int? rowCount;
  int? creditUsed;
  dynamic data;

  Result(
      {this.status,
      this.message,
      this.messageTr,
      this.systemTime,
      this.endpoint,
      this.rowCount,
      this.creditUsed,
      this.data});

  Result.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    messageTr = json["messageTR"];
    systemTime = (json["systemTime"] as num).toInt();
    endpoint = json["endpoint"];
    rowCount = (json["rowCount"] as num).toInt();
    creditUsed = (json["creditUsed"] as num).toInt();
    data = json["data"];
  }

  @override
  Result fromJson(Map<String, dynamic> json) {
    return Result.fromJson(json);
  }

  @override
  Map<String, dynamic> toJSon() {
    throw UnimplementedError();
  }
}
