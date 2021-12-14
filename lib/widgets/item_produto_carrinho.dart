import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/models/produto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ItemProdutoCarrinho extends StatefulWidget {

  late Produto produto;
  late int contador;
  late VoidCallback soma;
  late VoidCallback subtrai;
  late VoidCallback remover;

  ItemProdutoCarrinho({
    required this.produto,
    required this.contador,
    required this.soma,
    required this.subtrai,
    required this.remover
  });
  @override
  _ItemProdutoCarrinhoState createState() => _ItemProdutoCarrinhoState();
}

class _ItemProdutoCarrinhoState extends State<ItemProdutoCarrinho> {

  _verificaTela() {
    SizeWidgets size = SizeWidgets();
    var widthTela = MediaQuery
        .of(context)
        .size
        .width;
    var heightTela = MediaQuery
        .of(context)
        .size
        .height - MediaQuery
        .of(context)
        .padding
        .top;
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

  _converter(String valor){
    String moeda = valor;
    moeda = moeda.replaceAll('.', ',');
    if (moeda.contains(RegExp(r',[0-9]'))) {
      if (moeda.contains(RegExp(r',[0-9][0-9]')) ) {

      } else{
        moeda = moeda + '0';
      }
    }
    return moeda;
  }

  @override
  Widget build(BuildContext context) {
    SizeWidgets size = _verificaTela();
    var nome;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Stack(
          children: [
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap:  widget.remover,
                child: Icon(Icons.close, color: Colors.red ,size: size.textGrande)
              )),
            Positioned(
              right: 8,
              bottom: 8,
              child: Text('R\$'+ _converter(widget.produto.preco.toString()), style: TextStyle(
                fontSize: size.textMedio,
                color: Color(0xff00A930)
              ),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(size.paddingMedio),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: temaPadrao.primaryColor,
                      padding: EdgeInsets.all(2),
                      height: size.heigth * .11,
                      width: size.width * .085,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                         color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: widget.soma,
                                  icon: Icon(Icons.add, size: size.textPequeno),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:  EdgeInsets.only(top:size.paddingPequeno),
                                  child: Container(
                                    alignment: Alignment.center,
                                      child: Text(widget.contador.toString(), textAlign: TextAlign.center, style: TextStyle(
                                        fontSize: size.textPequeno
                                      ),)),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.remove, size: size.textPequeno,),
                                  onPressed: widget.subtrai,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.paddingMedio),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                      child: Image.network(widget.produto.fotos.first, width: size.width * .2, height: size.heigth * .11, fit: BoxFit.fitHeight,)
                  ),
                ),
                Container(
                  height: size.heigth *.11,
                  width: size.width * .48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child:
                        Wrap(
                          children:[
                            Text( widget.produto.nome,
                            style: TextStyle(
                            fontSize: size.textMedio,
                            fontWeight: FontWeight.bold
                          ),),
                         ]
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Informações desse produto'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(size.paddingMedio),
                                              child: Text(
                                                'Produto fesco selecionado especialmente por analistas em qualidade.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: size.textMedio
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Vencimento dentro dos prazos normais para uma ${widget.produto.nome}.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: size.textMedio
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
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: temaPadrao
                                                        .primaryColor)))
                                      ],
                                    );
                                  });

                            },
                            child: Text('+ informações', style: TextStyle(
                              fontSize: size.textMedio
                            ),),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


