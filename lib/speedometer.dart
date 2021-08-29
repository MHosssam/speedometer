library speedometer;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speedometer/handpainter.dart';
import 'package:speedometer/linepainter.dart';
import 'package:speedometer/speedtextpainter.dart';
import 'package:rxdart/rxdart.dart';

class SpeedOMeter extends StatefulWidget {
  final int start;
  final int end;
  final double highlightStart;
  final double highlightEnd;
  final ThemeData themeData;

  final PublishSubject<double> eventObservable;
  SpeedOMeter({
    required this.start,
    required this.end,
    required this.highlightStart,
    required this.highlightEnd,
    required this.themeData,
    required this.eventObservable,
  });

  @override
  _SpeedOMeterState createState() => new _SpeedOMeterState();
}

class _SpeedOMeterState extends State<SpeedOMeter>
    with TickerProviderStateMixin {
  // final int? start;
  // final int? end;
  // final double? highlightStart;
  // final double? highlightEnd;
  // final PublishSubject<double>? eventObservable;

  double val = 0.0;
  double? newVal;
  double textVal = 0.0;
  AnimationController? percentageAnimationController;
  StreamSubscription<double>? subscription;

  _SpeedOMeterState(
      // int start,
      // int end,
      // double highlightStart,
      // double highlightEnd,
      // PublishSubject<double> eventObservable,
      // this.start,
      // this.end,
      // this.highlightStart,
      // this.highlightEnd,
      // this.eventObservable,
      ) {
    // this.start = start;
    // this.end = end;
    // this.highlightStart = highlightStart;
    // this.highlightEnd = highlightEnd;
    // this.eventObservable = eventObservable;

    percentageAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    )..addListener(
        () {
          setState(
            () {
              val = lerpDouble(
                val,
                newVal,
                percentageAnimationController!.value,
              )!;
            },
          );
        },
      );
    subscription = widget.eventObservable.listen(
      (value) {
        textVal = value;
        (value >= widget.end)
            ? reloadData(widget.end.toDouble())
            : reloadData(value);
      },
    ); //(value) => reloadData(value));
  }

  reloadData(double value) {
    print(value);
    newVal = value;
    percentageAnimationController!.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.isCurrent == false) {
      return Text("");
    }
    return new Center(
      child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return new Container(
            height: constraints.maxWidth,
            width: constraints.maxWidth,
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Container(
                  child: new CustomPaint(
                    foregroundPainter: new LinePainter(
                      lineColor: this.widget.themeData.backgroundColor,
                      completeColor: this.widget.themeData.primaryColor,
                      startValue: widget.start,
                      endValue: widget.end,
                      startPercent: this.widget.highlightStart,
                      endPercent: this.widget.highlightEnd,
                      width: 40.0,
                    ),
                  ),
                ),
                new Center(
                  //   aspectRatio: 1.0,
                  child: new Container(
                    height: constraints.maxWidth,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        new CustomPaint(
                          painter: new HandPainter(
                            value: val,
                            start: widget.start,
                            end: widget.end,
                            color: this.widget.themeData.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Center(
                  child: new Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: this.widget.themeData.backgroundColor,
                    ),
                  ),
                ),
                new CustomPaint(
                  painter: new SpeedTextPainter(
                    start: widget.start,
                    end: widget.end,
                    value: this.textVal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
