import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/widgets/item_pedido.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class Pedidos extends StatefulWidget {

  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {

  final ControllerGet controllerGet = Get.put(ControllerGet());

  List<Widget> pedido = <Widget>[];
  bool carregando = true;

  _recuperarPedidos() async{
    Future.delayed(const Duration(seconds: 1)).then((value){
      setState(() {
        carregando = false;
      });
    });
  }

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

  @override
  void initState() {
    super.initState();
    _recuperarPedidos();
  }
  @override
  Widget build(BuildContext context) {

    SizeWidgets size = SizeWidgets();
    size = _verificaTela();

    return  Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.paddingGrande * 2.5),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: temaPadrao.primaryColor,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), topLeft: Radius.circular(15))
                    ),
                    height: size.heigth * .065,
                    width: size.width * .68,
                    child: Text('Pedidos', textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.white,
                        fontSize: size.textGrande
                    ),),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: temaPadrao.primaryColor,
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), topRight: Radius.circular(15))
                      ),
                      height: size.heigth * .065,
                      width: size.width * .2,
                      child: Padding(
                        padding: EdgeInsets.only(right: size.paddingMedio),
                        child:Image.asset('assets/icons/moped.png',
                            width: size.width * .1,
                            height: size.width * .1,
                            color:Colors.white),
                      )
                  ),
                ),
              ],
            ),
          ),
          carregando ? SizedBox(
            height: size.heigth * .85,
              width: size.width,
              child: const Center(child: CircularProgressIndicator()))
              :Container(
            padding: EdgeInsets.only(left: size.paddingPequeno, right: size.paddingPequeno),
            height: size.heigth * .8,
            child: controllerGet.pedidos.value.isNotEmpty
            ? SizedBox(
              height: size.heigth * .9,
              //width: size.width * .9,
              child: ListView.builder(
                itemCount: controllerGet.pedidos.value.length,
                itemBuilder: (_, index){
                  return Container(
                    height: size.heigth * .13,
                    width: size.width * .8,
                    child: ItemPedido(
                      context: context,
                      pedido: controllerGet.pedidos.value[index],
                    ),
                  );
                },
              ),
            )
                : Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text('Você ainda não fez nenhum Pedido!', textAlign: TextAlign.center ,style: TextStyle(
                    fontSize: size.textGrande
                ),),
              ),),
          ),
        ],
      ),
    );
  }
}
