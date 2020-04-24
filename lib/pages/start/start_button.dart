import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  StartButton();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Colors.pink,
//        color: const Color.fromRGBO(247, 64, 106, 1.0),
        borderRadius: BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: Text(
        "PLAY", //S.of(context).title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
