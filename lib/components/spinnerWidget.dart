import 'package:flutter/material.dart';

class Spinnerwidget extends StatelessWidget {
  const Spinnerwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 30,width: 30,
      child: Center(
        child: Container(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(238, 111, 66, 1),
            backgroundColor: Color.fromRGBO(238, 111, 66, 0.01),
            
          ),
        ),
      )
    );
  }
}