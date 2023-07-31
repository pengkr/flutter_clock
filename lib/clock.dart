import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = min(MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height) * 0.8;
    var date = DateTime.now();

    return CustomPaint(
      size: Size(size, size),
      painter: _Painter(date),
    );
  }
}

class _Painter extends CustomPainter {
  final DateTime date;

  _Painter(this.date);

  late Paint _paint;

  late double _size;
  late double _unit;

  double get _borderRadius => _size * 0.1;

  double get _clockRadius => _size * 0.42;

  double get _hourWidth => _unit * 0.7;

  double get _minuteWidth => _unit * 0.7;

  double get _secondWidth => _unit * 0.1;

  @override
  void paint(Canvas canvas, Size size) {
    _init(canvas, size);

    _drawBorder(canvas);

    canvas.translate(_size / 2, _size / 2);

    _drawClockBg(canvas);

    _drawCalibration(canvas);

    _drawNumber(canvas);

    _drawHour(canvas);

    _drawMinutes(canvas);

    _drawSecond(canvas);
  }

  void _init(Canvas canvas, Size size) {
    _size = min(size.width, size.height);
    _unit = _size / 20;

    _paint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xff363a41);
  }

  void _drawBorder(Canvas canvas) {
    _paint.color = const Color(0xff363a41);

    var rect = RRect.fromLTRBR(0, 0, _size, _size, Radius.circular(_borderRadius));
    canvas.drawRRect(rect, _paint);
  }

  void _drawClockBg(Canvas canvas) {
    _paint.color = const Color(0xfffbfafb);
    canvas.drawCircle(Offset.zero, _clockRadius, _paint);
  }

  void _drawCalibration(Canvas canvas) {
    for (var i = 0; i < 60; i++) {
      if (i % 5 == 0) {
        _paint.strokeWidth = _unit / 8;
        _paint.color = const Color(0xff383A41);
      } else {
        _paint.strokeWidth = _unit / 15;
        _paint.color = const Color(0xffE2E1E2);
      }

      canvas.save();
      canvas.rotate(i * pi / 30);
      canvas.drawLine(Offset(_clockRadius - _unit * 1.3, 0), Offset(_clockRadius - _unit * 0.3, 0), _paint);
      canvas.restore();
    }
  }

  void _drawNumber(Canvas canvas) {
    for (var i = 0; i < 12; i++) {
      var textPainter = TextPainter(
        text: TextSpan(
          text: i == 0 ? '12' : '$i',
          style: TextStyle(color: const Color(0xff363941), fontSize: _unit * 1.15, fontWeight: FontWeight.bold),
        ),
      )
        ..textDirection = TextDirection.ltr
        ..layout();

      canvas.save();
      canvas.rotate(i * pi / 6);
      canvas.translate(0, -(_clockRadius - _unit * 1.8 - textPainter.width / 2));
      canvas.rotate(-i * pi / 6);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  void _drawHour(Canvas canvas) {
    _paint.color = const Color(0xff363A41);

    canvas.save();
    canvas.rotate(date.hour * 2 * pi / 12 - pi / 2 + (date.minute / 60 * pi / 6));
    canvas.drawRRect(RRect.fromLTRBR(_unit, -_hourWidth / 2, _clockRadius * 0.6, _hourWidth / 2, Radius.circular(_unit)), _paint);
    canvas.drawRRect(RRect.fromLTRBR(0, -_unit / 5, _unit * 5, _unit / 5, Radius.circular(_unit)), _paint);
    canvas.restore();
  }

  void _drawMinutes(Canvas canvas) {
    _paint.color = const Color(0xff363A41);

    canvas.save();
    canvas.rotate(date.minute * 2 * pi / 60 - pi / 2);
    canvas.drawRRect(RRect.fromLTRBR(_unit, -_minuteWidth / 2, _clockRadius - _unit * 0.8, _minuteWidth / 2, Radius.circular(_unit)), _paint);
    canvas.drawRRect(RRect.fromLTRBR(0, -_unit / 5, _unit * 5, _unit / 5, Radius.circular(_unit)), _paint);
    canvas.restore();
  }

  void _drawSecond(Canvas canvas) {
    _paint.color = const Color(0xffE7463C);

    canvas.save();
    canvas.rotate(date.second * 2 * pi / 60 - pi / 2);
    canvas.drawRRect(RRect.fromLTRBR(-_clockRadius * 0.2, -_secondWidth / 2, _clockRadius - _unit * 0.3, _secondWidth / 2, Radius.circular(_unit)), _paint);
    canvas.drawCircle(Offset.zero, _clockRadius * 0.06, _paint);
    _paint.color = const Color(0xffE2E1E2);
    canvas.drawCircle(Offset.zero, _clockRadius * 0.02, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) {
    return oldDelegate.date != date;
  }
}
