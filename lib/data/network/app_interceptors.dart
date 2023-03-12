import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/auth/error_message.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;
  SharedPreferenceHelper sharedPreferenceHelper;

  AppInterceptors({required this.dio, required this.sharedPreferenceHelper});
  final _cache = <Uri, Response>{};
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest
    super.onRequest(options, handler);
    var token = sharedPreferenceHelper.loggedinToken;

    // if (options.data is FormData) {
    //   FormData formData = FormData();
    //   formData.fields.addAll(options.data.fields);
    //
    //   for (MapEntry mapFile in options.data.files) {
    //     formData.files.add(MapEntry(
    //         mapFile.key,
    //         MultipartFile.fromFileSync(mapFile.value.FILE_PATH,
    //         filename: mapFile.value.filename)));
    //   }
    //   options.data = formData;
    // }

    if (token != null) {
      // var expiration =  sharedPreferenceHelper.tokenRemainingTime;
      //  dio.interceptors.requestLock.lock();
      // dio.interceptors.errorLock.lock();
      //   tokenDio.get('/token').then((d) {
      //     //update csrfToken
      // await TokenRepository().persistAccessToken(response.accessToken);
      //       accessToken = response.accessToken;
      //     }).catchError((error, stackTrace) {
      //       handler.reject(error, true);
      //     }).whenComplete(() => dio.interceptors.requestLock.unlock());
      options.headers.putIfAbsent('Authorization', () => "Bearer $token" );
      options.headers.putIfAbsent('Locale', () => null);

    } else {
      print('Auth token is null');
    }
    return handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    print("DIOMYERROR ${err.message}");
    super.onError(err, handler);
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.response:
        switch (err.response!.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 401:
            ErrorMessage errorMessage =
                ErrorMessage.fromJson(err.response!.data);
            print('INTER_ERROR${errorMessage.message!}');
            throw UnauthorizedException(
                errorMessage.message!, err.requestOptions);
          case 403:
            ErrorMessage errorMessage =
            ErrorMessage.fromJson(err.response!.data);
            print('INTER_ERROR${errorMessage.message!}');
            throw UnauthorizedException(
                errorMessage.message!, err.requestOptions);
          case 500:
            print(err.message);
            // ErrorMessage errorMessage =
            //     ErrorMessage.fromJson(err.response!.data);
            print('500 Error --');
            throw NoQueryResultException(
                '500 Error', err.requestOptions);
          case 422:
            ErrorMessage errorMessage =

            throw EmailAlreadyTakenException(
                'Invalid Input', err.requestOptions);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        ErrorMessage errorMessage =
        ErrorMessage.fromJson(err.response!.data);
        print('OTHER_ERROR ${errorMessage.message}');
        throw OtherException(errorMessage.message!,err.requestOptions);
      default:
        throw BadRequestException(err.requestOptions);
    }
    return handler.next(err);
  }
}

class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Bad request';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);
  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioError {
  @override
  String message;
  UnauthorizedException(this.message, r) : super(requestOptions: r);

  @override
  String toString() {
    return message;
  }
}

class EmailAlreadyTakenException extends DioError {
  @override
  String message;
  EmailAlreadyTakenException(this.message, r) : super(requestOptions: r);

  @override
  String toString() {
    return message;
  }
}

class NoQueryResultException extends DioError {
  @override
  String message;
  NoQueryResultException(this.message, r) : super(requestOptions: r);

  @override
  String toString() {
    return message;
  }
}

class WrongPasswordException extends DioError {
  WrongPasswordException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    // TODO: implement toString
    return 'Your Password was not Correct';
  }
}

class NoInternetConnectionException extends DioError {
  @override
  String message;
  NoInternetConnectionException(this.message, r) : super(requestOptions: r);

  @override
  String toString() {
    return message;
  }
}

class OtherException extends DioError {
  @override
  String message;
  OtherException(this.message, r) : super(requestOptions: r);

  @override
  String toString() {
    return message;
  }
}



class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
