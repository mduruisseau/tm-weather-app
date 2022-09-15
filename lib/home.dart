import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_daily.dart';
import 'package:weather_app/models/weather_data.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  double _latitude = 50.6095001;
  double _longitude = 3.1337447;

  bool isLoading = false;
  dynamic _data;

  WeatherData? _weatherData;

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  _fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    Dio dio = Dio();
    try {
      var response = await dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': _latitude,
          'longitude': _longitude,
          'current_weather': true,
          'timezone': 'Europe/Paris',
          'daily': ['weathercode', 'temperature_2m_max', 'temperature_2m_min'],
        },
      );

      setState(() {
        isLoading = false;
        _data = response.data;
        _weatherData = WeatherData.fromJson(response.data);
      });
    } catch (e) {
      print(e);
      setState(() {
        _weatherData = null;
        isLoading = false;
      });
    }
  }

  Future<Response> _futureWeather() async {
    await Future.delayed(const Duration(seconds: 1));

    return await Dio().get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': _latitude,
        'longitude': _longitude,
        'current_weather': true,
        'timezone': 'Europe/Paris',
        'daily': ['weathercode', 'temperature_2m_max', 'temperature_2m_min'],
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _latitudeController.text = '$_latitude';
    _latitudeController.addListener(() {
      setState(() {
        _latitude = double.parse(_latitudeController.text);
      });
    });

    _longitudeController.text = '$_longitude';
    _longitudeController.addListener(() {
      setState(() {
        _longitude = double.parse(_longitudeController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSearchWidgets(),
            const Divider(indent: 8.0),
            _buildWithFutureBuilder(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: _buildWithoutClasses(),
            ),
            const Divider(indent: 8.0),
            _buildWeatherWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _buildWithFutureBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('With FutureBuilder'),
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return _buildWeatherData(
                      WeatherData.fromJson(snapshot.data!.data));
                } else if (snapshot.hasError) {
                  return _buildError(snapshot.error!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
            future: _futureWeather(),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildWithoutClasses() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    }

    if (_data == null) {
      return const Center(child: Text('No data'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temperature: ${_data['current_weather']['temperature'].toString()} °C',
        ),
        Text(
          'Wind: ${_data['current_weather']['windspeed'].toString()} km/h',
        ),
      ],
    );
  }

  Widget _buildWeatherData(WeatherData data) {
    return Text('Current Temperature: ${data.currentWeather?.temperature}');
  }

  Widget _buildError(Object error) {
    return Text('Error: $error');
  }

  Widget _buildSearchWidgets() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _latitudeController,
            decoration: const InputDecoration(
              hintText: 'Latitude',
              labelText: 'Latitude',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: TextField(
            controller: _longitudeController,
            decoration: const InputDecoration(
              hintText: 'Longitude',
              labelText: 'Longitude',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: ElevatedButton(
            onPressed: _fetchWeatherData,
            child: const Text('Refresh'),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherWidgets() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      );
    }

    if (_weatherData == null) {
      return const Center(
        child: Text('No weather data'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current weather",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Temperature: '),
                  Text('${_weatherData!.currentWeather!.temperature}°C'),
                ],
              ),
              Row(
                children: [
                  const Text('Wind Speed: '),
                  Text('${_weatherData!.currentWeather?.windSpeed}km/h'),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 8.0,
          indent: 16.0,
          endIndent: 16.0,
          color: Colors.red,
        ),
        ..._buildDaily(),
      ],
    );
  }

  List<Widget> _buildDaily() {
    List<Widget> widgets = [
      Text(
        "Daily weather",
        style: Theme.of(context).textTheme.headline4,
      ),
      const Row(
        children: [
          Expanded(
            child: Text('Date'),
          ),
          Expanded(
            child: Text(
              'Code',
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              'T° min',
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              'T° max',
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              'Detail',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
      const Divider(),
    ];
    WeatherDaily daily = _weatherData!.daily!;

    for (var i = 0; i < daily.time.length; i++) {
      widgets.add(
        Row(
          children: [
            Expanded(
              child: Text(daily.time[i]),
            ),
            Expanded(
              child: Text(
                '${daily.weatherCode![i]}',
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Text(
                '${daily.temperature2mMin![i]}',
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Text(
                '${daily.temperature2mMax![i]}',
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Weather on ${daily.time[i]} is ${daily.weatherCode![i]}',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.info),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }
}
