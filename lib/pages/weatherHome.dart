import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_interview/blocs/weatherBloc.dart';
import 'package:weather_interview/models/weatherModel.dart';

class WeatherHome extends StatefulWidget {
  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  final WeatherBloc _weatherBloc = BlocProvider.getBloc<WeatherBloc>();
  String userMail = "";
  String username = "";
  String celsius = "";
  bool _miniLoading = false;
  bool _validate = false;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userMail = await prefs.getString("userMail");
    setState(() {
      username = getUsername(userMail);
    });
  }

  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff2D2EC6),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              topLeft: Radius.circular(10)),
                          color: Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 15, right: 20),
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 55),
                                    child: Text(_weatherBloc.state, textScaleFactor: 0.81, style: TextStyle(
                                        color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600)),
                                  ),
                                  Spacer(),
                                  Text(
                                    username,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                    backgroundColor: Color(0xffE0E0E0),
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                      size: 17,
                                    ),
                                    maxRadius: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100,
                                margin: EdgeInsets.only(right: 10),
                                child: TextFormField(
                                  controller: _searchQuery,
                                  onFieldSubmitted: (search) {
                                    if(_searchQuery.text != "") {
                                      setState(() {
                                        _validate = false;
                                        _miniLoading = true;
                                        _weatherBloc.state = _searchQuery.text;
                                      });
                                      _weatherBloc.getWeather(_searchQuery.text).whenComplete(() {
                                        setState(() {
                                          _miniLoading = false;
                                        });
                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        _validate = true;
                                      });
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search cities around the world",
                                    hintStyle: TextStyle(
                                        color: Color(0xff676666), fontSize: 15),
                                    errorText: _validate ? 'Search cannot Be Empty' : null,
                                    errorStyle: TextStyle(color: Color(0xffFF6600)),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    prefixStyle: TextStyle(color: Colors.white),
                                    suffixIcon: _miniLoading
                                        ? Container(
                                          margin: EdgeInsets.only(right: 6),
                                          child: SpinKitDoubleBounce(
                                      color: Color(0xff2D2EC6),
                                      size: 17,
                                    ),
                                        )
                                        : Container(),
                                    suffixIconConstraints: BoxConstraints(
                                      maxWidth: 30
                                    ),
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffFAE2BE)
                                              .withOpacity(0.7)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xffECEBEB)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffECEBEB)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 50, left: 20),
                    child: StreamBuilder(
                        stream: _weatherBloc.fetchWeather,
                        builder:
                            (context, AsyncSnapshot<WeatherModel> weatherData) {
                          if (!weatherData.hasData)
                            return SpinKitDoubleBounce(
                                color: Colors.white, size: 30);
                          final weatherHasData = weatherData.data;
                          celsius = (weatherHasData.temp - 273.15)
                              .toString()
                              .substring(0, 4);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 100,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        celsius,
                                        textScaleFactor: 0.81,
                                        style: TextStyle(
                                            fontSize: 80,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Container(
                                        height: 15,
                                        width: 15,
                                        margin: EdgeInsets.only(top: 15),
                                        alignment: Alignment.topCenter,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 3)),
                                      )
                                    ],
                                  )),
                              RichText(
                                textScaleFactor: 0.81,
                                text: TextSpan(
                                    style: GoogleFonts.lato(
                                        color: Colors.white, fontSize: 17),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "${weatherHasData.description[0].toUpperCase()}"),
                                      TextSpan(
                                          text:
                                              "${weatherHasData.description.substring(1)}"),
                                    ]),
                              ),
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.15,
              minChildSize: 0.15,
              maxChildSize: 0.7,
              expand: true,
              builder: (BuildContext context, myscrollController) {
                return StreamBuilder(
                    stream: _weatherBloc.fetchWeather,
                    builder:
                        (context, AsyncSnapshot<WeatherModel> weatherData) {
                      if (!weatherData.hasData)
                        return SpinKitDoubleBounce(
                            color: Colors.white, size: 30);
                      final weatherHasData = weatherData.data;
                      var minCelsius = (weatherHasData.temp_min - 273.15).toString().substring(0, 4);
                      var maxCelsius = (weatherHasData.temp_max - 273.15).toString().substring(0, 4);
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(35),
                                topLeft: Radius.circular(35))),
                        child: ListView(
                          controller: myscrollController,
                          children: [
                            Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: IconButton(
                                        icon: Icon(Icons.cloud,
                                            color: Color(0xffF2B85E)),
                                        iconSize: 23,
                                        onPressed: null),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Text("Weather changes",
                                          textScaleFactor: 0.81,
                                          style: GoogleFonts.lato(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black.withOpacity(0.7)))),
                                  IconButton(
                                      icon: Icon(Icons.timelapse,
                                          color: Color(0xffF03260)),
                                      iconSize: 20,
                                      onPressed: null),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 25, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Minimum Temp.",
                                    textScaleFactor: 0.81,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xffD0C9C9)
                                    ),),
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          minCelsius,
                                          textScaleFactor: 0.81,
                                          style: TextStyle(
                                              fontSize: 70,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          margin: EdgeInsets.only(top: 15),
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black, width: 3)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 25, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Maximum Temp.",
                                    textScaleFactor: 0.81,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xffD0C9C9)
                                    ),),
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          maxCelsius,
                                          textScaleFactor: 0.81,
                                          style: TextStyle(
                                              fontSize: 70,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Container(
                                          height: 15,
                                          width: 15,
                                          margin: EdgeInsets.only(top: 15),
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black, width: 3)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 25, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Humidity",
                                    textScaleFactor: 0.81,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xffD0C9C9)
                                    ),),
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Text(
                                      weatherHasData.humidity.toString(),
                                      textScaleFactor: 0.81,
                                      style: TextStyle(
                                          fontSize: 70,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 25, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Speed",
                                    textScaleFactor: 0.81,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xffD0C9C9)
                                    ),),
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: Text(
                                      weatherHasData.speed.toString(),
                                      textScaleFactor: 0.81,
                                      style: TextStyle(
                                          fontSize: 70,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
