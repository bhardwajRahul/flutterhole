import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutterhole/core/models/exceptions.dart';
import 'package:flutterhole/core/models/failures.dart';
import 'package:flutterhole/dependency_injection.dart';
import 'package:flutterhole/features/api/data/datasources/api_data_source.dart';
import 'package:flutterhole/features/api/data/models/dns_query_type.dart';
import 'package:flutterhole/features/api/data/models/pi_status.dart';
import 'package:flutterhole/features/api/data/models/toggle_status.dart';
import 'package:flutterhole/features/api/data/repositories/connection_repository.dart';
import 'package:flutterhole/features/settings/data/models/pihole_settings.dart';
import 'package:injectable/injectable.dart';

@prod
@singleton
@RegisterAs(ConnectionRepository)
class ConnectionRepositoryDio implements ConnectionRepository {
  ConnectionRepositoryDio([Dio dio, ApiDataSource apiDataSource])
      : _dio = dio ?? getIt<Dio>(),
        _apiDataSource = apiDataSource ?? getIt<ApiDataSource>();

  final Dio _dio;
  final ApiDataSource _apiDataSource;

  @override
  Future<Either<Failure, int>> fetchHostStatusCode(
      PiholeSettings settings) async {
    if (settings.baseUrl?.isEmpty ?? true) {
      return Left(Failure('baseUrl is empty'));
    }

    try {
      final Response response = await _dio.get(settings.baseUrl);
      return Right(response.statusCode);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
          return Left(Failure('timeout'));
        case DioErrorType.CANCEL:
          return Right(0);
        case DioErrorType.RESPONSE:
          return Right(e.response.statusCode);
        case DioErrorType.DEFAULT:
        default:
          return Left(Failure('dio error', e));
      }
    }
  }

  @override
  Future<Either<Failure, PiStatusEnum>> fetchPiholeStatus(
      PiholeSettings settings) async {
    try {
      final ToggleStatus result = await _apiDataSource.pingPihole(settings);
      return Right(result.status);
    } on PiException catch (e) {
      return Left(Failure('fetchPiholeStatus failed', e));
    }
  }

  @override
  Future<Either<Failure, bool>> fetchAuthenticatedStatus(
      PiholeSettings settings) async {
    try {
      final DnsQueryTypeResult result =
          await _apiDataSource.fetchQueryTypes(settings);
      return Right(result != null);
    } on PiException catch (_) {
      return Right(false);
    }
  }
}
