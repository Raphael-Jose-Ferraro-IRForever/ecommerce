import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/route_generator.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Produtos extends StatefulWidget {

  @override
  _ProdutosState createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos>{

  final ControllerGet controllerGet = Get.put(ControllerGet());
  TextEditingController _observacoes = TextEditingController();
  bool obs = false;


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
  _preferenciasUser() async{

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('obs', false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _observacoes.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _preferenciasUser();
  }
  @override
  Widget build(BuildContext context) {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();
    String moeda = controllerGet.produto.value.preco.toString();
    moeda = moeda.replaceAll('.', ',');
    if (moeda.contains(RegExp(r',[0-9]'))) {
      if (moeda.contains(RegExp(r',[0-9][0-9]')) ) {

      } else{
        moeda = moeda + '0';
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.white,
            child: CheckboxListTile(
                value: obs,
                title: Text('Marque-me se deseja fazer uma observação'),
                onChanged: (value) async{
                  setState(() {
                    obs = value!;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('obs', obs);

                }),
          ),
          Container(
            height: size.heigth * .08,
            width: size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff7a1a1d),
                      Color(0xffC21A1D),
                    ]
                )
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(EdgeInsets.all(size.width * .04)),
                backgroundColor: MaterialStateProperty
                    .all<Color>(Colors.transparent),
                textStyle: MaterialStateProperty.all<
                    TextStyle>( const TextStyle(
                    color: Colors.white
                )),
              ),
              onPressed: (){
                  if(obs){
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Observações!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.textGrande,
                                fontWeight: FontWeight.bold),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    'Use esse campo para fazer suas observações!',
                                    textAlign: TextAlign.center),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingMedio),
                                  child: Container(
                                    width: size.width * .8,
                                  height: size.heigth * .2,
                                  child: TextField(
                                    textAlignVertical:
                                    TextAlignVertical.center,
                                    cursorColor:
                                    temaPadrao.primaryColor,
                                    controller: _observacoes,
                                    enableSuggestions: true,
                                    keyboardType:
                                    TextInputType.multiline,
                                    textInputAction: TextInputAction.go,
                                    maxLines: 15,
                                    style: TextStyle(
                                      fontSize: size.textPequeno,
                                    ),
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    textCapitalization:
                                    TextCapitalization.words,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () {
                                controllerGet.produto.value.observacoes = _observacoes.text;
                                controllerGet.produtosCarrinho.value.add(controllerGet.produto.value);
                                controllerGet.contador.value.add(1);
                                controllerGet.resetar();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, RouteGenerator.ROTA_CARRINHO,
                                        (route) => false);
                              },
                              child: const Text(
                                'Prosseguir',
                                style: TextStyle(color: Colors.green),
                              )),
                        ],
                      ));
                    } else{
                    controllerGet.produto.value.observacoes = 'Nenhuma';
                    controllerGet.produtosCarrinho.value.add(controllerGet.produto.value);
                    controllerGet.contador.value.add(1);
                    controllerGet.resetar();
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteGenerator.ROTA_CARRINHO,
                            (route) => false);
                  }
              },
              child: Text('Comprar', style: TextStyle(
                fontSize: size.textGrande,
                color: Colors.white,
              ),),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Hero(
                        tag: controllerGet.produto.value.idProduto,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                            child: CarouselSlider(
                                items: controllerGet.produto.value.fotos.map((e){
                                  return Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage(e), fit: BoxFit.contain)),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  autoPlay: true,
                                )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.paddingMedio, top: size.paddingMedio, right: size.paddingMedio),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controllerGet.produto.value.nome, textAlign: TextAlign.start, style: TextStyle(
                            fontSize: size.textGrande,
                            fontWeight: FontWeight.bold
                          ),),
                          Padding(
                            padding: EdgeInsets.only(top: size.paddingPequeno),
                            child: Row(
                              children: [
                                Expanded(
                                  flex:3,
                                  child: Row(
                                    children: [
                                      RatingBar.builder(
                                        ignoreGestures: true,
                                        initialRating: double.parse(controllerGet.produto.value.avaliacao),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: size.width * .042,
                                        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(right: size.paddingPequeno),
                                    alignment: Alignment.centerRight,
                                    child: Text('R\$$moeda', style: TextStyle(
                                      fontSize: size.textGrande,
                                    color: temaPadrao.primaryColor,
                                    fontStyle: FontStyle.italic
                                    ),),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.paddingGrande),
                            child: Text('Descrição', style: TextStyle(
                              fontSize: size.textMedio, fontWeight: FontWeight.bold
                            ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.paddingGrande),
                            child: Text(controllerGet.produto.value.descricao, textAlign: TextAlign.justify ,style: TextStyle(
                              fontSize: size.textPequeno,
                              fontStyle: FontStyle.italic,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.only( top: size.paddingPequeno),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteGenerator.ROTA_MENU, (_) => false);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: temaPadrao.primaryColor,
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), topRight: Radius.circular(15))
                          ),
                          height: size.heigth * .07,
                          width: size.width * .17,
                          child: Padding(
                            padding: EdgeInsets.only(left: size.paddingPequeno),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_ios_outlined, color: Colors.white,size: size.width * .05,),
                                Icon(Icons.arrow_back_ios_outlined, color: Colors.white,size: size.width * .041,),
                                Icon(Icons.arrow_back_ios_outlined, color: Colors.white,size: size.width * .032),
                              ],
                            ),
                          ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: size.paddingPequeno),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: temaPadrao.primaryColor,
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), topLeft: Radius.circular(15))
                        ),
                        height: size.heigth * .065,
                        width: size.width * .15,
                        child: Icon(
                          FontAwesomeIcons.shoppingCart,
                          color: Colors.white,
                          size: size.width * .05,
                        )
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
