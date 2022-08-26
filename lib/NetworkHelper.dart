import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  String url = 'https://api.openrouteservice.org/v2/directions/';
  String apiKey = '5b3ce3597851110001cf624873cebc2a142845bb9664bb7d3ff59f94';
  String joutrayMode = 'driving-car';

  double? startLng = 103.25005265867213;
  double? startLat = 16.249237503471164;

  double? endLng = 103.25682021214791;
  double? endLat = 16.239770738725504;


  NetworkHelper(
      {required this.startLng,
        required this.startLat,
        required this.endLng,
        required this.endLat});

  Future getData() async {
    Uri url2uri = Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf624873cebc2a142845bb9664bb7d3ff59f94&start=103.25005265867213,16.249237503471164&end=103.25682021214791,16.239770738725504');
    http.Response response = await http.get(url2uri);
    print('https://api.openrouteservice.org/v2/directions/${joutrayMode}?api_key=${apiKey}&start=${startLng},${startLat}&end=${endLng},${endLat}');
    if (response.statusCode == 200) {
      String data = response.body;
      print("ดึงข้อมูล");
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}