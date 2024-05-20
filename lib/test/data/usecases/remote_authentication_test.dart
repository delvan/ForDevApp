// ignore: depend_on_referenced_packages
import 'package:test/test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';
// ignore: depend_on_referenced_packages
import 'package:faker/faker.dart';

class RemoteAuthetication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthetication({required this.httpClient, required this.url});

  Future<void>? auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void>? request({required String url});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call HttpClient with correct URL', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();

    final sut = RemoteAuthetication(httpClient: httpClient, url: url);
    await sut.auth();

    verify(httpClient.request(url: url));
  });
}
