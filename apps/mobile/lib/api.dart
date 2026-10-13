import 'dart:async';
import 'dart:io' as io;

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the API lives. Release builds talk to production; debug builds to
/// the host's local API, which the emulator reaches at 10.0.2.2
/// (docs/API.md "Base URL"). `--dart-define=API_URL=…` overrides either.
const apiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: kReleaseMode
      ? 'https://gn-api-c763.onrender.com'
      : 'http://10.0.2.2:3300',
);

/// A failed call, in the API's error shape (docs/API.md "Errors"): branch on
/// [code], show [message]. [fields] maps form fields to their problem (422).
class ApiError implements Exception {
  const ApiError(
    this.status,
    this.code,
    this.message, [
    this.fields = const {},
  ]);
  final int status;
  final String code, message;
  final Map<String, String> fields;

  static const network = ApiError(
    0,
    'network',
    'Can’t reach rally right now. Check your connection and try again.',
  );

  /// Any error from a call, as an [ApiError].
  factory ApiError.from(Object e) {
    if (e is ApiError) return e;
    if (e is DioException) {
      final res = e.response;
      final data = res?.data;
      final err = data is Map ? data['error'] : null;
      if (err is Map) {
        final fields = err['fields'];
        return ApiError(
          res!.statusCode ?? 0,
          '${err['code'] ?? 'error'}',
          '${err['message'] ?? 'Something went wrong. Try again.'}',
          fields is Map
              ? {for (final f in fields.entries) '${f.key}': '${f.value}'}
              : const {},
        );
      }
      if (res == null) return network;
      return ApiError(
        res.statusCode ?? 0,
        'error',
        'Something went wrong. Try again.',
      );
    }
    return const ApiError(0, 'error', 'Something went wrong. Try again.');
  }

  /// For a form: the first field's problem on `validation_failed`, else the message.
  String get detail => code == 'validation_failed' && fields.isNotEmpty
      ? fields.values.first
      : message;

  @override
  String toString() => 'ApiError($status $code: $message)';
}

/// Keeps the session token. Secure storage on the phone (docs/API.md "Auth").
abstract class TokenStore {
  Future<String?> read();
  Future<void> write(String? token);
}

class SecureTokenStore implements TokenStore {
  static const _key = 'session_token';
  final _storage = const FlutterSecureStorage();

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String? token) => token == null
      ? _storage.delete(key: _key)
      : _storage.write(key: _key, value: token);
}

class MemoryTokenStore implements TokenStore {
  MemoryTokenStore([this.token]);
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String? t) async => token = t;
}

/// The generated client behind one Dio with the headers every call needs:
/// the token, `X-App-Version` and `X-Platform`. A 401 drops the session and
/// a 426 asks for an update, through [onSignedOut] and [onUpdateRequired].
class Api {
  Api({
    required this.appVersion,
    required this.store,
    String baseUrl = apiUrl,
    HttpClientAdapter? adapter,
  }) : _adapter = adapter {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        // Render's free tier sleeps when idle and takes up to a minute to
        // answer the first request after that.
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 75),
      ),
    );
    if (adapter != null) dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
    client = ApiClient(dio: dio, interceptors: const []);
  }

  final String appVersion;
  final TokenStore store;
  final HttpClientAdapter? _adapter;
  late final ApiClient client;
  String? _token;
  void Function()? onSignedOut;
  void Function()? onUpdateRequired;

  String get platform => io.Platform.isIOS ? 'ios' : 'android';

  /// The User-Agent the auth endpoints require; sessions are named by it.
  String get userAgent => 'rally/$appVersion ($platform)';

  bool get signedIn => _token != null;

  Future<void> restore() async => _token = await store.read();

  Future<void> setToken(String? token) async {
    _token = token;
    await store.write(token);
  }

  void _onRequest(RequestOptions o, RequestInterceptorHandler h) {
    final t = _token;
    if (t != null) o.headers['authorization'] = 'Bearer $t';
    o.headers['x-app-version'] = appVersion;
    o.headers['x-platform'] = platform;
    h.next(o);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler h) async {
    final status = e.response?.statusCode;
    if (status == 401 &&
        _token != null &&
        e.requestOptions.headers['authorization'] != null) {
      await setToken(null);
      onSignedOut?.call();
    } else if (status == 426) {
      onUpdateRequired?.call();
    } else if (_retryable(e)) {
      // Idempotent calls get one retry on a dropped connection.
      e.requestOptions.extra['retried'] = true;
      try {
        return h.resolve(await client.dio.fetch(e.requestOptions));
      } on DioException catch (again) {
        return h.next(again);
      }
    }
    h.next(e);
  }

  bool _retryable(DioException e) =>
      e.response == null &&
      e.requestOptions.extra['retried'] != true &&
      const {'GET', 'PUT', 'DELETE'}.contains(e.requestOptions.method) &&
      (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout);

  AppApi get app => client.getAppApi();
  AuthApi get auth => client.getAuthApi();
  GamesApi get games => client.getGamesApi();
  MeApi get me => client.getMeApi();
  UsersApi get users => client.getUsersApi();
  ListingsApi get listings => client.getListingsApi();
  ConnectionsApi get connections => client.getConnectionsApi();
  PlayApi get play => client.getPlayApi();
  NotificationsApi get notifications => client.getNotificationsApi();
  SafetyApi get safety => client.getSafetyApi();

  /// Uploads bytes to a signed storage URL (avatars, docs/API.md "Images").
  Future<void> upload(
    String url,
    Map<String, String> headers,
    List<int> bytes,
  ) async {
    final dio = Dio();
    if (_adapter != null) dio.httpClientAdapter = _adapter;
    await dio.put<void>(
      url,
      data: Stream.fromIterable([bytes]),
      options: Options(headers: {...headers, 'content-length': bytes.length}),
    );
  }
}
