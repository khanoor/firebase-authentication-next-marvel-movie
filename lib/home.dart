import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  String CurrentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  Future<void> getCurrent(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (date != null) {
      setState(() {
        CurrentDate = DateFormat("yyyy-MM-dd").format(date);
      });
    }
  }

  List data = [];

  Future<String?> getmovie() async {
    var response = await http.get(
      Uri.parse('https://www.whenisthenextmcufilm.com/api'),
    );
    var convert_data_to_json = json.decode(response.body);

    setState(() {
      data.add(convert_data_to_json);
      print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    getmovie();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 30),
              primary: Color(0xff5189C6),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5),
              ),
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
          child: const Text(
            'Previous',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(padding: const EdgeInsets.only(left: 25)),
        ElevatedButton(
          onPressed: () {
            getCurrent(context);
          },
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 30),
              primary: Color.fromARGB(255, 255, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5),
              ),
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
          child: Text(
            CurrentDate,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(padding: const EdgeInsets.only(left: 25)),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 30),
              primary: Color(0xff5189C6),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5),
              ),
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
          child: const Text(
            'Next',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ]),
      body: data.length > 0
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                  ),
                  child: Container(
                    height: 600,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(data[0]['poster_url']),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            data[0]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "Overview:",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              data[0]['overview'],
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Release Date: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(data[0]['release_date'])
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                "Type: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(data[0]['type'])
                            ],
                          )
                        ],
                      ),
                    )),
              ]))
          : Container(child: Center(child: CircularProgressIndicator())),
    ));
  }
}
