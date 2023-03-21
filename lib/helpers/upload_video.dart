// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

var _uploadUrl = "https://upload.ssshht.com/upload";

Future<bool> uploadVideoToServer(
    String filePath, String objectId, String type) async {
  bool waiting = true;
  bool status = false;

  var request =
      http.MultipartRequest("POST", Uri.parse('$_uploadUrl/$objectId'));

  request.files.add(await http.MultipartFile.fromPath('video', filePath));

  await request.send().then((response) async {
    await http.Response.fromStream(response).then((onValue) {
      waiting = false;
      if (onValue.body == 'ok') {
        status = true;
      } else {
        status = false;
      }
    });
  });

  for (var i = 0; i < 60; i++) {
    if (!waiting) {
      i = 60;
    }
    await Future.delayed(const Duration(seconds: 5));
  }
  return status;
}
