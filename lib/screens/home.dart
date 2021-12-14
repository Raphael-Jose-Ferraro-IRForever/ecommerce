import 'dart:async';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/route_generator.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/screens/pesquisa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ControllerGet controllerGet = Get.put(ControllerGet());
  int indiceEmpresa = 0;

  TextEditingController _controllerPesquisa = TextEditingController();

  List listIconesCategoriasHome = [];


  _verificaTela() {
    SizeWidgets size = SizeWidgets();
    var widthTela = MediaQuery.of(context).size.width;
    var heightTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    size.width = widthTela;
    size.heigth = heightTela;
    size.textPequeno = widthTela * 0.04;
    size.textGrande = widthTela * 0.06;
    size.textMedio = widthTela * 0.05;
    size.paddingGrande = widthTela * 0.035;
    size.paddingMedio = widthTela * 0.02;
    size.paddingPequeno = widthTela * 0.01;

    return size;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _controllerPesquisa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();

    return Scaffold(
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(children: [
              Stack(children: <Widget>[
                Container(
                    height: size.heigth * .17,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Color(0xff802126),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: size.paddingMedio,
                        right: size.paddingMedio,
                        top: size.paddingGrande),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                      child: SizedBox(
                                        height: size.width * .2,
                                        width: size.width * .2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                              'https://i.imgur.com/wyuL5CV.jpg',
                                              fit: BoxFit.fitHeight),
                                        ),
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.paddingMedio,
                                            bottom: size.paddingGrande,
                                            top: size.paddingMedio),
                                        child: Text(
                                          'Rise Delivery',
                                          //textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: size.textGrande * 1.15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.paddingMedio),
                                        child: Wrap(
                                          children: [
                                            SizedBox(
                                              height: size.heigth * .05,
                                              width: size.width * .62,
                                              child: AnimatedTextKit(
                                                repeatForever: true,
                                                animatedTexts: [
                                                  FadeAnimatedText('Bem-Vindo '+controllerGet.nomeUsuario.value +'!', duration: Duration(seconds: 5),textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: size.textPequeno + 1)),
                                                  FadeAnimatedText('O que deseja hoje?',duration: Duration(seconds: 5),textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: size.textPequeno + 1)),
                                                  FadeAnimatedText('Que tal uma maçã?',duration: Duration(seconds: 5),textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: size.textPequeno + 1)),
                                                  FadeAnimatedText('Temos uma super oferta!',duration: Duration(seconds: 5),textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: size.textPequeno + 1)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: size.heigth * .04),
                                    child: IconButton(
                                      onPressed: (){
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, RouteGenerator.ROTA_LOGIN, (_) => false);
                                      },
                                        icon: Icon(FontAwesomeIcons.signInAlt, size: size.width * .07,color: Colors.white,)),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.paddingGrande),
                            child: Center(
                              child: SizedBox(
                                width: size.width * .85,
                                height: size.heigth * .06,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  cursorColor: temaPadrao.primaryColor,
                                  controller: _controllerPesquisa,
                                  enableSuggestions: true,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.search,
                                  onChanged: (value) {
                                    setState(() {
                                      controllerGet.pesquisa.value = value;
                                      controllerGet.pesquisaBool.value = false;
                                    });
                                  },
                                  onSubmitted: (value) {
                                    setState(() {
                                      controllerGet.pesquisaBool.value = true;
                                    });
                                  },
                                  style: TextStyle(
                                    fontSize: size.textPequeno,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30)),
                                    hintText: 'Pesquise um produto aqui!',
                                    contentPadding: EdgeInsets.all(4),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: size.textGrande,
                                    ),
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                            ),
                          ),
                        ]))
              ]),
             Obx(()=> !controllerGet.pesquisaBool.value
                  ? Padding(
                padding: EdgeInsets.only(
                    left: size.paddingPequeno,
                    right: size.paddingPequeno,
                    top: size.paddingMedio),
                child: SizedBox(
                  height: size.heigth * .8,
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.paddingGrande,
                            left: size.paddingPequeno,
                            bottom: size.paddingGrande),
                        child: Text(
                          'Melhores Avaliados',
                          style: TextStyle(fontSize: size.textGrande - 2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselSlider(
                            items: controllerGet.imagensProdutos.map((e) => Image.network(e, width: size.width * .9, fit: BoxFit.fill,)).toList(),
                            options: CarouselOptions(
                              onPageChanged: (index, _) {
                                indiceEmpresa = index;
                              },
                              autoPlayAnimationDuration:
                              const Duration(seconds: 1),
                              height: size.heigth * .3,
                              viewportFraction: 0.75,
                              enlargeCenterPage: true,
                              autoPlay: true,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.paddingGrande,
                            left: size.paddingPequeno,
                            bottom: size.paddingGrande),
                        child: Text(
                          'Destaques do dia',
                          style: TextStyle(fontSize: size.textGrande - 2),
                        ),
                      ),
                      SizedBox(
                        height: size.heigth * .32,
                        child: ListView.builder(
                          itemCount: controllerGet.produtos.value.length,
                            itemBuilder: (_, index){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              trailing:  const Icon(FontAwesomeIcons.dollarSign, size: 20,),
                              title: Text(controllerGet.produtos.value[index].nome),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child:Image.network(controllerGet.produtos.value[index].fotos[0])),
                              onTap: (){
                                controllerGet.produto.value = controllerGet.produtos.value[index];
                                Navigator.pushNamedAndRemoveUntil(
                                    context, RouteGenerator.ROTA_PRODUTO, (_) => false);
                              },
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              )
                  : Padding(
                padding: EdgeInsets.only(top: size.paddingPequeno),
                child: Pesquisa(),
              ))
            ]),
          ],
        ));
  }
}
