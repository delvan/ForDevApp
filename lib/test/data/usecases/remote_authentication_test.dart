// ignore: depend_on_referenced_packages

import 'package:test/test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';
// ignore: depend_on_referenced_packages
import 'package:faker/faker.dart';

import 'package:fordev_app/domain/usecases/authentication.dart';
import 'package:fordev_app/data/http/http.dart';
import 'package:fordev_app/data/usecases/usecases.dart';

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
    final params = AuthenticationParms(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut!.auth(params);

    verify(httpClient!.request(
        url: url!,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });
}
