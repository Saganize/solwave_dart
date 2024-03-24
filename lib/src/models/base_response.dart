class BaseResponse<T> {
  T? data;
  final String status;
  final String? statusMessage;
  List<ServerError>? errors;

  BaseResponse({
    this.data,
    required this.status,
    this.statusMessage,
    this.errors,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    if (json['data'] != null) {
      if (json['data'] is List<dynamic>) {
        List<dynamic> dataList = json['data'];
        return BaseResponse<T>(
          data: dataList.map((item) => fromJsonT(item)).toList().first,
          status: json['status'],
          statusMessage: getStatusMessage(json['status']),
          errors: json['errors'] != null
              ? List<ServerError>.from(
                  json['errors'].map((error) => ServerError.fromJson(error)),
                )
              : null,
        );
      } else {
        return BaseResponse<T>(
          data: fromJsonT(json['data']),
          status: json['status'],
          statusMessage: getStatusMessage(json['status']),
          errors: json['errors'] != null
              ? List<ServerError>.from(
                  json['errors'].map((error) => ServerError.fromJson(error)),
                )
              : null,
        );
      }
    } else {
      return BaseResponse<T>(
        status: json['status'],
        statusMessage: getStatusMessage(json['status']),
        errors: json['errors'] != null
            ? List<ServerError>.from(
                json['errors'].map((error) => ServerError.fromJson(error)),
              )
            : null,
      );
    }
  }
}

class ServerError {
  final String? field;
  final String? message;

  ServerError({
    this.field,
    this.message,
  });

  factory ServerError.fromJson(Map<String, dynamic> json) {
    return ServerError(
      field: json['field'],
      message: json['message'],
    );
  }
}

String getStatusMessage(status) {
  switch (status) {
    case "SAGANIZE_TOO_MANY_REQUESTS":
      return "Too many requests. Please try again later.";
    case "SAGANIZE_USER_EXISTS":
      return "User already exists. Please try logging in.";
    case "SAGANIZE_USER_NOT_FOUND":
      return "User not found. Please check your email address and try again.";
    case "SAGANIZE_API_KEY_INVALID":
      return 'Something unexpected happened. Please try again later';
    case "SAGANIZE_LOGIN_FAILED":
      return "Login failed. Please check your credentials and try again.";
    case "SAGANIZE_TRANSACTION_ERROR":
      return "We encountered an issue processing your transaction. Please try again later.";
    case "SAGANIZE_AUTH_WEBVIEW_EXPIRED":
      return 'Something unexpected happened. Please try again later';
    case "SAGANIZE_AUTH_WEBVIEW_NOT_FOUND":
      return 'Something unexpected happened. Please try again later';
    default:
      return 'Something unexpected happened. Please try again later';
  }
}
