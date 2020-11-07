class WeatherModel {
  dynamic temp;
  String description;
  String main;
  dynamic humidity;
  dynamic speed;
  dynamic temp_min;
  dynamic temp_max;

  WeatherModel(
      {this.temp,
        this.description,
        this.main,
        this.humidity,
        this.speed,
        this.temp_min,
        this.temp_max
      });

  WeatherModel.fromJson(Map<String, dynamic> item) {
    this.temp = item['main']['temp'];
    this.description = item['weather'][0]['description'];
    this.main = item['weather'][0]['main'];
    this.humidity = item['main']['humidity'];
    this.speed = item['wind']['speed'];
    this.temp_min = item['main']['temp_min'];
    this.temp_max = item['main']['temp_max'];
  }
}