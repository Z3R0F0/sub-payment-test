import 'package:dio/dio.dart';

class CustomFailure extends DioException {
  final String? customMessage;
  final int? statusCode;

  @override
  String get message => customMessage ?? '';

  CustomFailure({
    this.statusCode,
    this.customMessage,
  }) : super(requestOptions: RequestOptions(path: ''));

  @override
  String toString() {
    return message.isNotEmpty
        ? message
        : "Oops! An error occurred. Please try again.";
  }
}

class CustomUnknownException extends CustomFailure {
  final String? errorDetails;

  CustomUnknownException([this.errorDetails])
      : super(customMessage: errorDetails);

  @override
  String toString() {
    return message.isNotEmpty
        ? message
        : "Oops! Something unexpected happened. Please try again.";
  }
}
