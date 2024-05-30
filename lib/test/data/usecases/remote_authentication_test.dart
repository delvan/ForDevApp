import 'package:test/test.dart';
// ignore: depend_on_referenced_packages
import 'package:mockito/mockito.dart';
// ignore: depend_on_referenced_packages
import 'package:faker/faker.dart';

// ignore: depend_on_referenced_packages
import 'package:fordev_app/domain/usecases/authentication.dart';
import 'package:fordev_app/data/http/http.dart';
import 'package:fordev_app/data/usecases/usecases.dart';
// ignore: depend_on_referenced_packages
import 'package:fordev_app/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthetication? sut;
  HttpClientSpy? httpClient;
  String? url;
  AuthenticationParms? params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthetication(httpClient: httpClient!, url: url!);
    params = AuthenticationParms(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    when(httpClient?.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut!.auth(params!);

    verify(httpClient!.request(
        url: url!,
        method: 'post',
        body: {'email': params!.email, 'password': params!.secret}));
  });

  test('Should throws UnexpectedError if HttpClient return 400', () async {
    when(httpClient?.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throws UnexpectedError if HttpClient return 404', () async {
    when(httpClient?.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throws UnexpectedError if HttpClient return 500', () async {
    when(httpClient?.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throws InvalidCredentialsError if HttpClient return 401',
      () async {
    when(httpClient?.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final accessToken = faker.guid.guid();

    when(httpClient?.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'accessToken': accessToken, 'name': faker.person.name()});

    final account = await sut!.auth(params!);

    expect(account!.token, accessToken);
  });
}
