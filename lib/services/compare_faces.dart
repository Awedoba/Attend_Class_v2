import 'dart:convert';
import 'dart:io';

import 'package:attend_classv2/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CompareFaces {
  static verifyFaces(String verifingImage, File image) async {
    // File first = _verifingImage;
    String first = verifingImage;
    File second = image;
    print('first $first');
    print('second $second');
    Uri uri = Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare');

    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.fields['api_key'] = apiKey;
    request.fields['api_secret'] = apiSecret;
    request.fields['image_url1'] = first;
    // request.files.add(await http.MultipartFile.fromPath(
    //     // 'image_file1',
    //     'image_url1',
    //     first
    //     // .path
    //     ,
    //     contentType: new MediaType('application', 'x-tar')));
    request.files.add(await http.MultipartFile.fromPath(
        'image_file2', second.path,
        contentType: new MediaType('application', 'x-tar')));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await http.Response.fromStream(response);
      // var response = await http.get(request);
      var resultToJson = jsonDecode(result.body);
      // var result = jsonDecode(response.body);
      return resultToJson;
    } else {
      return 'Error';
    }
  }
}
