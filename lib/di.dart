import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void setup() {
  // getIt.registerLazySingleton<WebServices>(() => WebServices(_dio()));
  // getIt.registerLazySingleton<WebRepo>(() => WebRepo(getIt()));
  // getIt.registerLazySingleton<AppCubit>(() => AppCubit(repo: getIt()));
  // getIt.registerLazySingleton<UserApi>(() => UserApi(Dio()));
  // getIt.registerLazySingleton<UserRepoB>(() => UserRepoB(getIt()));
  // getIt.registerLazySingleton<AppCubit>(() => AppCubit(repo: getIt()));
}

Dio _dio() {
  return Dio()
    ..options.connectTimeout = 1000
    ..options.receiveTimeout = 10 * 1000
    ..interceptors.add(LogInterceptor(requestBody: true, error: true, responseBody: true, requestHeader: true, request: true, responseHeader: true));
}
