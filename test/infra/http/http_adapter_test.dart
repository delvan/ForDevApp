// ignore: depend_on_referenced_packages

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:fordev_app/data/http/http.dart';

class HttpAdapter {
  final HttpClient httpClient;
  final String url;
  final String method;

  HttpAdapter({required this.httpClient, required this.url, required this.method});

  Future<void> auth() async {
    await httpClient.request(url: url, method: method);
  }
}

class ClientSpy extends Mock implements HttpClient {}

void main() {
  group("post", () {
    test("Should call post with correct values", () async {
      final url = faker.internet.httpUrl();
      final client = ClientSpy();
      final sut = HttpAdapter(httpClient: client, url: url, method: "post");

      await sut.auth();

      verify(client.request(url: url, method: "post"));
    });
  });
}
