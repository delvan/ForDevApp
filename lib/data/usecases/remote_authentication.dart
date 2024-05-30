import '../../domain/entities/entities.dart';

import '../../domain/helpers/helpers.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthetication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthetication({required this.httpClient, required this.url});

  Future<AccountEntity>? auth(AuthenticationParms params) async {
    final body = RemoteAuthenticationParms.fromDomain(params).toJson();

    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return AccountEntity.fromJson(httpResponse!);
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParms {
  final String email;
  final String password;

  RemoteAuthenticationParms({required this.email, required this.password});

  factory RemoteAuthenticationParms.fromDomain(AuthenticationParms params) =>
      RemoteAuthenticationParms(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
