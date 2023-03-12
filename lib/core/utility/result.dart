class Result<T> {
  final T? success;

  final Error? error;

  Result({this.success, this.error});
}

class Success<T> extends Result {
  final T? data = null;
  Success(data);
}

class Error extends Result {
  final String? message;
  final int? status;

  Error({this.message, this.status});
}

class NoInternetError extends Error {
  @override
  final String? message;

  NoInternetError({this.message});
}

class TokenExpired extends Error {}

class ServerError extends Error {
  @override
  final String? message;

  ServerError({this.message});
}

class HttpError extends Error {
  @override
  final String? message;
  final String? http;

  HttpError({this.message, this.http});
}
