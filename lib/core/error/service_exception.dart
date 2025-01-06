/// ServiceException is a custom exception class that is
/// used to handle exceptions that occur in the service layer.
class ServiceException implements Exception {
  /// ServiceException constructor
  ServiceException({
    this.message = 'Unexpected Error Occured',
    this.code = 404,
  });

  /// message is a error message
  final String? message;

  /// code is a error code
  final int? code;

  @override
  String toString() {
    return 'ServiceException{message: $message, code: $code}';
  }
}
