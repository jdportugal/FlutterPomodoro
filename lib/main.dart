import 'dart:async';

import 'package:flutter/material.dart';
import 'hover_extension.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _timer;
  int min_25 = 1500;
  int min_5 = 300;
  int _start = 1500;

  int initial_time = 1500;

  int paused = 0;
  int reset_5 = 0;
  int reset_25 = 0;
  int reset = 0;
  double size_center_button = 0;

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (seconds < 1) {
      return "Pomodoro completed";
    }
    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }
    return "$hoursStr:$minutesStr:$secondsStr";
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start < 1) {
          paused = 1;
          _start = initial_time;
        } else {
          if (paused == 0) {
            _start = _start - 1;
            size_center_button = _start * 100 / initial_time + 100;
          }
          if (reset_25 == 1) {
            _start = min_25;
            reset_25 = 0;
            initial_time = min_25;
          }
          if (reset_5 == 1) {
            _start = min_5;
            reset_5 = 0;
            initial_time = min_5;
          }
          if (reset == 1) {
            _start = min_25;
            reset = 0;
            initial_time = min_25;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Color.fromARGB(255, 41, 37, 69)),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 20,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "Pomodoro",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w100,
                        fontSize: 100),
                  ),
                ),
              ),
              Expanded(
                  flex: 20,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      formatHHMMSS(_start),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica Neue",
                          fontWeight: FontWeight.w100,
                          fontSize: 100),
                    ),
                  )),
              Spacer(),
              Expanded(flex: 30, child: center_widget(paused)),
              Spacer(),
              Expanded(
                flex: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 20,
                      child: button("Pause", paused, 345, 105, 50)
                          .showCursosOnHover,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 20,
                      child: button("25 Min", reset_25, 345, 105, 50)
                          .showCursosOnHover,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 20,
                      child: button("5 Min", reset_5, 345, 105, 50)
                          .showCursosOnHover,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 20,
                      child: button("Reset", reset, 345, 105, 50)
                          .showCursosOnHover,
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget center_widget(int paused) {
    if (paused == 1) {
      return Container();
    } else {
      return AspectRatio(
          aspectRatio: 1 / 1,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            button("", 1, size_center_button, size_center_button, 500),
            button("", 0, 100, 100, 500),
          ]));
    }
  }

  Widget button(String text, int status, double button_width,
      double button_height, double radius) {
    if (status == 0) {
      return unpressed_button(text, button_width, button_height, radius);
    } else {
      return pressed_button(text, button_width, button_height, radius);
    }
  }

  Widget unpressed_button(
      String text, double button_width, double button_height, double radius) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Color.fromARGB(255, 41, 37, 69),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -2,
                  color: Color.fromARGB(255, 29, 25, 51),
                  offset: Offset(7, 7),
                  blurRadius: 15,
                )
              ]),
        ),
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Color.fromARGB(255, 41, 37, 69),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -20,
                  color: Colors.white,
                  offset: Offset(-5, -5),
                  blurRadius: 15,
                )
              ]),
        ),
        MaterialButton(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
              width: button_width,
              height: button_height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(radius))),
              child: Container(
                  alignment: Alignment.center,
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica Neue",
                          fontWeight: FontWeight.w200,
                          fontSize: 40,
                        ),
                      )))),
          onPressed: () {
            setState(() {
              if (text == "Pause") {
                if (paused == 1) {
                  paused = 0;
                } else {
                  paused = 1;
                }
              }
              if (text == "25 Min") {
                reset_25 = 1;
              }
              if (text == "5 Min") {
                reset_5 = 1;
              }
              if (text == "Reset") {
                reset = 1;
              }
            });
          },
        )
      ],
    );
  }

  Widget pressed_button(
      String text, double button_width, double button_height, double radius) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Color.fromARGB(255, 41, 37, 69),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -12,
                  color: Colors.white,
                  offset: Offset(5, 5),
                  blurRadius: 15,
                )
              ]),
        ),
        Container(
          width: button_width,
          height: button_height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: Color.fromARGB(255, 41, 37, 69),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -2,
                  color: Color.fromARGB(255, 29, 25, 51),
                  offset: Offset(-7, -7),
                  blurRadius: 15,
                )
              ]),
        ),
        MaterialButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
                width: button_width,
                height: button_height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(radius))),
                child: Container(
                    alignment: Alignment.center,
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Helvetica Neue",
                            fontWeight: FontWeight.w200,
                            fontSize: 40,
                          ),
                        )))),
            onPressed: () {
              setState(() {
                if (text == "Pause") {
                  if (paused == 1) {
                    paused = 0;
                  } else {
                    paused = 1;
                  }
                }
              });
            })
      ],
    );
  }
}
