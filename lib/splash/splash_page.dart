import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Image.asset(
          'assets/img/protester.png',
          width: 350,
          height: 350,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
