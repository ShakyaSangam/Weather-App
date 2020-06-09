class WheatherModel {
  var temp;
  var pressure;
  var tempmin;
  var tempmax;
  var sealevel;

  WheatherModel({this.temp, this.pressure, this.tempmin, this.tempmax, this.sealevel});

  WheatherModel.fromJson(Map<String, dynamic> parsedJson) {
    temp = parsedJson["temp"];
    pressure = parsedJson["pressure"];
    tempmin = parsedJson["temp_min"];
    tempmax = parsedJson["temp_max"];
    sealevel = parsedJson["sea_level"];
  }
}
