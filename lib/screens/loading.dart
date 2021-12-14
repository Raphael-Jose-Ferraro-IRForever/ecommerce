import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  widthTela() {
    return MediaQuery.of(context).size.width;
  }

  heightTela() {
    return MediaQuery.of(context).size.height;
  }

  _verificaTela() {
    SizeWidgets size = SizeWidgets();

    if (widthTela() <= 360) {
      size.google = heightTela() / 2;
      size.paddingPequeno = heightTela() / 9;
    } else {
      size.google = heightTela() / 2.5;
      size.paddingPequeno = heightTela() / 8;
    }

    return size;
  }

  @override
  Widget build(BuildContext context) {
    SizeWidgets sizeWidgets = SizeWidgets();
    sizeWidgets = _verificaTela();
    return Scaffold(
      body: SingleChildScrollView(
            child: Container(
              width: widthTela(),
              height: heightTela(),
              color: Colors.grey[300],
              child: Padding(
                padding: EdgeInsets.only(top: sizeWidgets.paddingPequeno),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        width: widthTela(),
                        height: widthTela(),
                        child: const FlareActor("assets/animations/logo.flr",
                            fit: BoxFit.contain, animation: "play"),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right:  8),
                          child: Container(
                            alignment: Alignment.center,
                            width: widthTela() / 1.1,
                            height: widthTela() / 3.5,
                            decoration: BoxDecoration(
                              color: temaPadrao.primaryColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextLiquidFill(
                              text: 'Carregando...',
                              loadDuration: Duration(seconds: 3),
                              boxBackgroundColor: temaPadrao.primaryColor,
                              waveColor: Colors.black54,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: widthTela() / 9,
                                fontWeight: FontWeight.bold,
                              ),
                              boxHeight: widthTela() / 5.8,
                              boxWidth: widthTela() / 1.2,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
