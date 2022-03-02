import 'dart:convert';
import 'dart:io';

class HttpService {
  Future<dynamic> httpGet(Uri url, String token) async {
    try {
      final HttpClient _httpClient = HttpClient();
      HttpClientRequest request = await _httpClient.getUrl(url);
      request.headers.set('content-type', 'application/json');

      if (token.isNotEmpty) {
        request.headers.set('Authorization', token);
      }

      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      _httpClient.close();

      return jsonDecode(reply);
    } catch (error) {
      //
    }
  }
}
