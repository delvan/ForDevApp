import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthetication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthetication({required this.httpClient, required this.url});

  Future<void>? auth(AuthenticationParms parms) async {
    await httpClient.request(url: url, method: 'post', body: parms.toJson());
  }
}
