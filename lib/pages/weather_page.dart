import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_widgets/animated_widgets.dart'; // Import for animations
import 'package:www/models/weather_model.dart';
import 'package:www/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:www/services/gemini_ai.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // apikey
  final _weatherService = WeatherService('b5af7fd195c1a50eb6d617a622154979');
  Weather? _weather;
  bool _showContent = false; // Flag to control animation visibility

  // fetch weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  final TextEditingController _questionController = TextEditingController();
      String? _answer;

      void _askQuestion() async {
        final question = _questionController.text;
        print("question: $question");
        if (question.isNotEmpty) {
          print('wallls $question');	
          try{
            final answer = await askQuestion(question, _weather!);
            setState(() {
              _answer = answer;
            });
          }
          catch(e)
          {
            print("has error");
            print(e);
          }
          print("askquestion $_answer");
        }
      }

String getWeatherAnimation(String? mainCondition, double? temperature) {
  if (mainCondition == null) return 'assets/sunny.json';

  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assets/bulutlu.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/Animation - 1714162921812.json';
    case 'thunderstorm':
      return 'assets/firtina.json';
    case 'clear':
      return 'assets/gunesli.json';
    case 'snow':
      return 'assets/images/eldiven.png';
    default:
      return 'assets/gunesli.json';
  }
}
String getClothesImage(double temperature) {
  if (temperature <= 17) {
    return 'assets/images/montt.png';
  } else if (temperature >= 22) {
    return 'assets/images/elbisee.png';
  } else if (temperature >= 19) {
    return 'assets/images/tshirtt.png';
  }
  return 'assets/images/tshirtt.png'; // Varsayılan olarak t-shirt görseli
}
int _currentPage = 0; // Initially set to the home page

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showContent = true;
      });
    });
  }

 

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.cyan,
    body: SingleChildScrollView(
      child: AnimatedOpacity(
        opacity: _showContent ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
        child: AnimatedScale(
          scale: _showContent ? 1.0 : 0.8,
          duration: Duration(seconds: 1),
          alignment: Alignment.topCenter,
          child: _currentPage == 0
              ? Column(
                  children: [
                    SizedBox(height: 2),
                    _weather?.mainCondition != null
                        ? Lottie.asset(
                            getWeatherAnimation(_weather!.mainCondition, _weather!.temperature),
                            width: 450,
                            height: 300,
                          )
                        : CircularProgressIndicator(),
                    Text(
                      _weather?.cityName ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_weather?.temperature ?? 0}°C',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      _weather?.mainCondition ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '${_weather?.wind}°v wind speed',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black, // İç yuvarlak rengi
                          radius: 100,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white, // Dış yuvarlak rengi
                          radius: 120,
                        ),
                        CircleAvatar(
                          radius: 90,
                          backgroundColor: Color.fromARGB(0, 234, 213, 20), // İçteki resmin etrafındaki yuvarlak için arka planın şeffaf olduğundan emin olun
                          backgroundImage: AssetImage(getClothesImage(_weather?.temperature ?? 0)),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5), // İkinci yuvarlak rengi ve opaklık ayarı
                          radius: 140,
                        ),
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 80),
                      const Text(
                        'Ask Your Question',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          hintText: 'Type your question here...',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _askQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink, // Use backgroundColor instead of primary
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'ASK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_answer != null)
                        Text(
                          'Answer: ${_answer.toString()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
        ),
      ),
    ),
    bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Colors.cyan,
      items: const <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.chat_bubble, size: 30),
      ],
      onTap: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    ),
  );
}
}