import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/route_generator.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/models/produto.dart';
import 'package:ecommerce/widgets/item_produto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class Pesquisa extends StatefulWidget {
  @override
  _PesquisaState createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {

  final ControllerGet controllerGet = Get.put(ControllerGet());
  List<Produto> produtos = [];

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
    size.paddingGrande = widthTela * 0.03;
    size.paddingMedio = widthTela * 0.02;
    size.paddingPequeno = widthTela * 0.01;

    return size;
  }

  _procurarProduto(){

    for(var x in controllerGet.produtos.value){
      if(x.nome.toLowerCase().contains(controllerGet.pesquisa.value.toLowerCase())) {
        produtos.add(x);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _procurarProduto();
  }

  @override
  Widget build(BuildContext context) {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();
    return  Container(
      height: size.heigth * .68,
      child:GridView.builder(
          itemCount: produtos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1),
          itemBuilder: (context, index) {
            return ItemProduto(
              icon: Icons.favorite,
              produto: produtos[index],
              onTapItem: () {
                controllerGet.produto.value = produtos[index];
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteGenerator.ROTA_PRODUTO, (_) => false);
                });
            }
            )
          );
  }
}
