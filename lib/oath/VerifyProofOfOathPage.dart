import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/home/ShapesPainter.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

import '../navigation/app_drawer/app_drawer.dart';

class VerifyProofOfOathPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDrawerBloc, AppDrawerState>(
        builder: (BuildContext context, AppDrawerState state) {
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.grey,
              title: Text(
                AppLocalizations.of(context)!.verifyTitle,
                style: TextStyle(color: Colors.white),
              ),
              leading: (() {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    BlocProvider.of<AppDrawerBloc>(context)
                        .add(VerifyPageEvent());
                  },
                );
              })()),
          body: Stack(children: <Widget>[
            CustomPaint(
              size: Size.infinite,
              child: Container(
                height: MediaQuery.of(context).size.height,
              ),
              painter:
                  ShapesPainter((state as VerifyProofOfOathState).othersPhone),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    alignment: Alignment(0.0, 0.76),
                    child: Text(
                      AppLocalizations.of(context)!.oathVerified +
                          "\n\n Phone: " +
                          (state).othersPhone,
                      textScaleFactor: 1.8,
                    ),
                  ),
                )),
          ]));
    });
  }
}
