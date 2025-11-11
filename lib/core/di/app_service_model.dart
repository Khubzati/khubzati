import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../network/dio_client.dart';
import '../network/retrofit_client.dart';
import '../routes/app_router.dart';

@module
abstract class AppServiceModel {
  @lazySingleton
  AppRouter get appRouter => AppRouter();

  @lazySingleton
  Dio get dio => DioClient.createDio();

  @lazySingleton
  RetrofitClient get retrofitClient => RetrofitClient(dio);

  @preResolve
  Future<StreamingSharedPreferences> preferences() =>
      StreamingSharedPreferences.instance;

  @preResolve
  Future<SharedPreferences> sharedPreferences() =>
      SharedPreferences.getInstance();

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}
