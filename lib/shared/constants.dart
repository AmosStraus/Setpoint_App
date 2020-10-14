import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// filling the input and password  ///
const textInputDecoration = InputDecoration(
  alignLabelWithHint: true,
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.brown, width: 2.0),
  ),
);

/// The loading widget ///
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[100],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.red,
          size: 50.0,
        ),
      ),
    );
  }
}

class SimpleLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitChasingDots(
      color: Colors.red,
      size: 50.0,
    ));
  }
}

class RedCircluarText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  RedCircluarText({this.text, this.size, this.fontWeight});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red[200],
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            )),
      ),
    );
  }
}
