import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/route_generator.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/screens/carrinho.dart';
import 'package:ecommerce/screens/home.dart';
import 'package:ecommerce/screens/loading.dart';
import 'package:ecommerce/screens/pedidos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  final ControllerGet controllerGet = Get.put(ControllerGet());
  bool _loadingInProgress = true;

  _verificaTela() {
    SizeWidgets size = SizeWidgets();
    var widthTela =  MediaQuery.of(context).size.width;
    var heightTela =  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    size.width = widthTela;
    size.heigth = heightTela;
    size.textPequeno = widthTela * 0.04;
    size.textGrande = widthTela * 0.06;
    size.textMedio = widthTela * 0.05;
    size.paddingGrande = widthTela * 0.03;
    size.paddingMedio = widthTela * 0.02;
    size.paddingPequeno = widthTela * 0.01;

    return size;
  }

  _recuperarDadosUser() async {
    final prefs = await SharedPreferences.getInstance();

  }
  void _dataLoaded() {
    setState(() {
      _loadingInProgress = false;
    });
  }

  Future<bool> _onWillpop() async {
    SizeWidgets size = _verificaTela();
    bool resultado = false;

    await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('AVISO!', textAlign: TextAlign.center, style: TextStyle(
              fontSize: size.textGrande, fontWeight: FontWeight.bold,
            ),),
            content: Text('Deseja realmente fechar o App?', style: TextStyle(
                fontSize: size.textMedio
            ),),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    resultado = false;
                  },
                  child: Text('Não', style: TextStyle(
                      fontSize: size.textMedio
                  ),)
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    resultado = true;
                  },
                  child: Text('Sim', style: TextStyle(
                      fontSize: size.textMedio
                  ),)
              ),
            ],
          );
        }
    );
    return resultado;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) => _dataLoaded());
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingInProgress) {
      return Loading();
    } else {
      return buildMenu(context);
    }
  }

  Widget buildMenu(BuildContext context) {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();
    controllerGet.cadastarProdutos();
    List<Widget> telas = [
       Home(),
       Carrinho(),
       Pedidos(),
    ];

    return WillPopScope(
      onWillPop:() {
       return _onWillpop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(()=> telas[controllerGet.indiceTela.value]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: temaPadrao.primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(FontAwesomeIcons.opencart),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROTA_CARRINHO, (route) => false);
          },
        ),
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: Obx( ()=> Padding(
          padding: EdgeInsets.only(left: size.width * .28, right: size.width * .28),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              height: size.heigth * .06,
              width: size.width * .2,
              decoration:
                  BoxDecoration(
                     color: temaPadrao.primaryColor,
                    borderRadius:const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child:
                    controllerGet.indiceTela.value != 0
                        ? IconButton(
                            icon: Icon(FontAwesomeIcons.houseUser,
                                size: size.width * .05,
                                color: Colors.white38),
                            onPressed: () {
                              controllerGet.indiceTela.value = 0;
                            })
                        : GestureDetector(
                          onTap: (){
                            controllerGet.indiceTela.value = 0;
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.houseUser,
                                    size: size.width * .04,
                                    color: Colors.white),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6, left: 2),
                                  child: Text(
                                    'Home',
                                    style: TextStyle(
                                        fontSize: size.textPequeno * .5, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                        ) ,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: controllerGet.indiceTela.value != 2
                        ? GestureDetector(
                            child: Image.asset('assets/icons/moped.png',
                                width: size.width * .08,
                                height: size.width * .08,
                                color:controllerGet.indiceTela.value  == 2
                                    ? Colors.white
                                    : Colors.white38),
                            onTap: () {
                              setState(() {
                                controllerGet.indiceTela.value = 2;
                              });
                            })
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/icons/moped.png',
                                  width: size.width * .06,
                                  height: size.width * .06,
                                  color:controllerGet.indiceTela.value  == 2
                                      ? Colors.white
                                      : Colors.white38),
                              Text(
                                'Pedidos',
                                style: TextStyle(
                                    fontSize: size.textPequeno * .5, color: Colors.white),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
