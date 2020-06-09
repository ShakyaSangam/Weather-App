import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/wheatherModel.dart';
import 'package:decimal/decimal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var formkey = GlobalKey<FormState>();
  String controller;
  TextEditingController value;

  Future<WheatherModel> fetchApi() async {
    var response = await http.get(
        "https://api.openweathermap.org/data/2.5/weather?q=${controller == null ? "Dharan" : controller}&APPID=4fc204a3175fc36ff3b7882339f312b4");
    // print(response.body);
    var dec = json.decode(response.body);
    var model = WheatherModel.fromJson(dec['main']);
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    "Today's Weather",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black12,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: value,
                          decoration: InputDecoration(
                              labelText: "Location", hintText: "Location..."),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Invalid Location";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              controller = value;
                            });
                          }),
                      RaisedButton(
                        onPressed: () {
                          if (formkey.currentState.validate()) {
                            formkey.currentState.save();
                            value.clear();
                          }
                        },
                        child: Text("Check"),
                      )
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                  future: fetchApi(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      final temp =
                          Decimal.parse(snapshot.data.temp.toString()) -
                              Decimal.parse("273.15"); // * kelvin to celsius
                      final tempmin =
                          Decimal.parse(snapshot.data.tempmin.toString()) -
                              Decimal.parse("273.15");
                      final tempmax =
                          Decimal.parse(snapshot.data.tempmax.toString()) -
                              Decimal.parse("273.15");
                      return Container(
                        padding: EdgeInsets.only(top: 80),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "${temp.toString()}° C",
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 25),
                                  ),
                                  Text(controller == null
                                      ? "Dharan"
                                      : controller)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text("High"),
                                        Text(
                                          "${tempmax.toString()}° C",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.lightBlueAccent),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text("Low"),
                                        Text(
                                          "${tempmin.toString()}° C",
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text("Pressure"),
                                      Text(
                                        "${snapshot.data.pressure.toString()}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.redAccent),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
