import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musa_app/core/utils/exceptions.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;
  String? _authToken;

  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> _getHeaders({bool requiresAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _httpClient.get(
      url,
      headers: _getHeaders(requiresAuth: requiresAuth),
    );
    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, {dynamic body, bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _httpClient.post(
      url,
      headers: _getHeaders(requiresAuth: requiresAuth),
      body: body != null ? json.encode(body) : null,
    );
    return _processResponse(response);
  }

  Future<dynamic> put(String endpoint, {dynamic body, bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _httpClient.put(
      url,
      headers: _getHeaders(requiresAuth: requiresAuth),
      body: body != null ? json.encode(body) : null,
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _httpClient.delete(
      url,
      headers: _getHeaders(requiresAuth: requiresAuth),
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        try {
          return json.decode(response.body);
        } catch (e) {
          return response.body;
        }
      }
      return null;
    } else {
      dynamic errorBody;
      try {
        errorBody = json.decode(response.body);
      } catch (e) {
        errorBody = response.body;
      }

      switch (response.statusCode) {
        case 400:
          throw BadRequestException(
            errorBody?['message'] ?? 'Bad request',
            errorBody,
          );
        case 401:
          throw UnauthorizedException(
            errorBody?['message'] ?? 'Unauthorized',
            errorBody,
          );
        case 403:
          throw ForbiddenException(
            errorBody?['message'] ?? 'Forbidden',
            errorBody,
          );
        case 404:
          throw NotFoundException(
            errorBody?['message'] ?? 'Not found',
            errorBody,
          );
        case 409:
          throw ConflictException(
            errorBody?['message'] ?? 'Conflict',
            errorBody,
          );
        case 500:
        case 502:
        case 503:
          throw ServerException(
            errorBody?['message'] ?? 'Server error',
            errorBody,
          );
        default:
          throw ApiException(
            'Unknown error occurred',
            response.statusCode,
            errorBody,
          );
      }
    }
  }
} 