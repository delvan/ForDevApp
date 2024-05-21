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
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void>? request({required String url, required String method});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthetication? sut;
  HttpClientSpy? httpClient;
  String? url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthetication(httpClient: httpClient!, url: url!);
  });

  test('Should call HttpClient with correct values', () async {
    await sut!.auth();

    verify(httpClient!.request(url: url!, method: 'post'));
  });
}
