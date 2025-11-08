import 'package:http/http.dart' as http;

class ApiServices {
  Future<http.Response> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> postData(String url, Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(url), body: data);
    return response;
  }
}
