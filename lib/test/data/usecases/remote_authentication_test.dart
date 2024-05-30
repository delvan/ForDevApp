import 'package:fordev_app/data/http/http_error.dart';
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

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(httpClient?.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthetication(httpClient: httpClient!, url: url!);
    params = AuthenticationParms(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut!.auth(params!);

    verify(httpClient!.request(
        url: url!,
        method: 'post',
        body: {'email': params!.email, 'password': params!.secret}));
  });

  test('Should throws UnexpectedError if HttpClient return 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throws UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throws UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throws InvalidCredentialsError if HttpClient return 401',
      () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut!.auth(params!);

    expect(account!.token, validData['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient return 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut!.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
}
