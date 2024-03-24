// import 'package:dio/dio.dart';

// class AuthInterceptor implements Interceptor {
//   final Dio dio;

//   AuthInterceptor(this.dio);

//   @override
//   void onError(DioError error, ErrorInterceptorHandler handler) async {
//     if (error.response?.statusCode == 401) {
//       // Handle authentication errors by refreshing the auth tokens and retrying the request
//       final newAuthToken = await refreshAuthTokens();
//       dio.options.headers['Authorization'] = 'Bearer $newAuthToken';
//       handler.resolve(dio.request(error.request.url, error.request.data));
//     } else {
//       // Handle other errors as needed
//       handler.next(error);
//     }
//   }

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {}

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {}
// }
