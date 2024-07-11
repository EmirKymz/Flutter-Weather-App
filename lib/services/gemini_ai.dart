// import 'dart:convert';
// import 'dart:js_interop';
// import 'package:http/http.dart' as http;
import 'package:www/models/weather_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// Future<String> askQuestion(String question, Weather weather) async {
//   print("heeloworld");
//   // API anahtarınızı güvenli bir şekilde alın

//   final url = Uri.parse('https://aistudio.googleapis.com/v1/text');

//   final body = {
//     'prompt': question,
//     'temperature': '${weather.temperature}', // Hava durumu bilgisini ekleyin
//     'maxTokens': 64, // Cevap uzunluğunu sınırlayın (isteğe bağlı)
//   };

//   final headers = {'Authorization': 'Bearer $apiKey'};

//   final response = await http.post(url, body: jsonEncode(body), headers: headers);

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     // print("data[text] : ${data['text'].toString()}");
//     return data['text'];
//   } else {
//     print('Error: ${response.statusCode}');
//     return 'Soru sorulurken hata oluştu.';
//   }
// }

Future<String> askQuestion(String question, Weather weather) async {
  print("heeloworld");
  // API anahtarınızı güvenli bir şekilde alın
  const apiKey = 'Your api key';

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  //final prompt = question + ' hava bugun ' + weather.temperature.toString() + ' derece';
  final prompt = question;
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print("promt $prompt");
  return response.text.toString();
}
