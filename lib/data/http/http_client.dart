
import 'dart:convert';

import 'package:http/http.dart';

abstract class HttpClient {
  Future<Map>? request(
      { required String? url,
        required String? method,
        Map? body
      });


  Future<Response>? post(
      String url, {Map<String, String>? headers, Object? body, Encoding? encoding});
}
