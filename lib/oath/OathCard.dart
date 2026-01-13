import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:protestersoath/l10n/app_localizations.dart';
import 'package:protestersoath/utils/sizing.dart';

class OathCard extends StatelessWidget {
  final String text;
  final bool isLogin;
  final bool shortCard;
  final int index;

  OathCard(this.text, this.isLogin, this.index, this.shortCard);

  @override
  Widget build(BuildContext context) {
    final double width = screenWidth(context);
    final double height =
        screenHeight(context) - MediaQuery.of(context).padding.top;
    double aspect = width / height;

    double heightPart1 = height / (27);
    double aspectPart1 = 3 / aspect;
    double heightPart2 = height / (30);
    double aspectPart2 = 3 / aspect;
    double padTop = this.shortCard ? 0:2;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      heightPart1 = height / (40);
      aspectPart1 = 2 / aspect;
      heightPart2 = height / (55);
      aspectPart2 = 2 / aspect;
    }
    else if (aspect < .5) { // wider phones.
      heightPart1 = height / (29);
      aspectPart1 = 3.8 / aspect;
      heightPart2 = height / (32);
      aspectPart2 = 3.8 / aspect;
    }

    double fontSize = (heightPart1 - aspectPart1).toInt().toDouble();
    double minFontSize = (heightPart2 - aspectPart2).toInt().toDouble();

    if (fontSize < 12) { fontSize = 12; }
    if (minFontSize < 10) { minFontSize = 10; }

    return Center(
      child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Padding(padding: EdgeInsets.only(left:10,right:10,bottom:0,top:padTop),
            child: Container(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: AutoSizeText(
                    _getOathText(context),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                    stepGranularity: 1,
                    maxLines: 3,
                    minFontSize: minFontSize,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                        color: Colors.black),
                  )),
          ))),
    );
  }

  String _getOathText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (shortCard) {
      switch (index) {
        case 0:
          return l10n.shortPoint00;
        case 1:
          return l10n.shortPoint01;
        case 2:
          return l10n.shortPoint02;
        case 3:
          return l10n.shortPoint03;
        case 4:
          return l10n.shortPoint04;
        case 5:
          return l10n.shortPoint05;
        case 6:
          return l10n.shortPoint06;
        case 7:
          return l10n.shortPoint07;
        case 8:
          return l10n.shortPoint08;
        default:
          return '';
      }
    } else {
      switch (index) {
        case 0:
          return l10n.point00;
        case 1:
          return l10n.point01;
        case 2:
          return l10n.point02;
        case 3:
          return l10n.point03;
        case 4:
          return l10n.point04;
        case 5:
          return l10n.point05;
        case 6:
          return l10n.point06;
        case 7:
          return l10n.point07;
        case 8:
          return l10n.point08;
        default:
          return '';
      }
    }
  }
}
