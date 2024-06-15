// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter({required this.client});

  Future<void> request({
    required Uri url,
  }) async {
    await client.post(url);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group("post", () {
    test("deve chamar o metodo post com valores corretos", () async {
      final url = faker.internet.httpUrl();
      final Uri uri = Uri.parse(url);
      final client = ClientSpy();
      final sut = HttpAdapter(client: client);

      //when(() async => client.post(uri)).thenAnswer(getData());

      when(() => client.post(uri));

      await sut.request(url: uri);

      verify(() => client.post(uri)).called(1);
    });
  });
}
