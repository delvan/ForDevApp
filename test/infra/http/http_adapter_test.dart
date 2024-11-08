
import 'package:faker/faker.dart';
import 'package:fordev_app/data/http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';


class HttpAdapter {

  final HttpClient client;

  HttpAdapter(this.client);

  Future<void>? request(
      { required String? url,
        required String? method
      }) async{
    final headers = {
                'content-type': 'application/json',
                'accept': 'application/json'
              };
    await client.post(url!, headers: headers );

  }

}

class ClientSpy extends Mock implements HttpClient{}

void main(){
  HttpAdapter? sut;
  ClientSpy? client;
  String? url;

  setUp((){
    client = ClientSpy();
    sut = HttpAdapter(client!);
    url = faker.internet.httpsUrl();
  });


  group('post', () {
    test('Should call post with correct values', () async {
      await sut!.request(url: url, method: 'post');

      verify(client!.post(url!,
          headers:
              {
                'content-type': 'application/json',
                'accept': 'application/json'
              }

              ));

    });

  });
}



