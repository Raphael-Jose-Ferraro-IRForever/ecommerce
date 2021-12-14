import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/models/produto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class ItemProduto extends StatefulWidget {

  Produto produto;
  VoidCallback onTapItem;
  IconData icon;

  ItemProduto({
    required this.produto,
    required this.icon,
    required this.onTapItem,
  });
  @override
  _ItemProdutoState createState() => _ItemProdutoState();
}

class _ItemProdutoState extends State<ItemProduto> {

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
  Widget build(BuildContext context) {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();
    String moeda = widget.produto.preco.toString();
    moeda = moeda.replaceAll('.', ',');
    if (moeda.contains(RegExp(r',[0-9]'))) {
      if (moeda.contains(RegExp(r',[0-9][0-9]')) ) {

      } else{
        moeda = moeda + '0';
      }
    }

    return GestureDetector(
      onTap: widget.onTapItem,
      child: Card(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: size.width * .35,
                  child: Hero(
                    tag: widget.produto.idProduto,
                      child: CarouselSlider(
                          items: widget.produto.fotos.map((e){
                            return Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(e), fit: BoxFit.contain)),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            aspectRatio: 16/9,
                            viewportFraction: 1,
                            enlargeCenterPage: false,
                            autoPlay: true,
                          ))),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: size.paddingPequeno, top: size.paddingPequeno, right: size.paddingPequeno),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.produto.nome, style: TextStyle(
                            fontSize: size.textPequeno + 2,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: RatingBar.builder(
                                ignoreGestures: true,
                                initialRating: double.parse(widget.produto.avaliacao),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize:  size.width * .026,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: size.paddingPequeno - 2),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'R\$ ' + moeda, style: TextStyle(
                                    fontSize: size.textPequeno,
                                    fontStyle: FontStyle.italic
                                ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


