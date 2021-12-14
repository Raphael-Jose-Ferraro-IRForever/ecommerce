import 'package:ecommerce/models/pedido.dart';
import 'package:ecommerce/models/produto.dart';
import 'package:get/get.dart';

class ControllerGet extends GetxController{

  var indiceTela = 0.obs;
  var pesquisaBool = false.obs;
  var encontrou = 0.obs;
  var pesquisa =''.obs;
  var nomeUsuario = ''.obs;
  var contador = [].obs;
  var produtos = <Produto>[].obs;
  var produtosCarrinho = <Produto>[].obs;
  var produto = Produto().obs;
  var pedido = Pedido().obs;
  var pedidos = <Pedido>[].obs;
  var imagensProdutos = ['https://i.imgur.com/Ta2HOEd.png','https://i.imgur.com/juYC1mx.png', 'https://i.imgur.com/3x9vRPm.png', 'https://i.imgur.com/ollAsLG.png', 'https://i.imgur.com/GeoKFbK.png'];
  var nomeProdutos = ['Pêra', 'Abacaxi',  'Manga', 'Maçã', 'Banana'];

  void resetar(){
    indiceTela.value = 0;
    pesquisa.value = '';
    update();
  }
  void cadastrarUser( String nome){
    nomeUsuario.value = nome;
    update();
  }
  void cadastarProdutos(){
    produtos.value = <Produto>[];
    Produto produto;
    for(var x =0; x<5; x++) {
      produto = Produto();
      produto.avaliacao = '5';
      produto.idProduto = x.toString();
      produto.fotos = [imagensProdutos[x]];
      produto.nome = nomeProdutos[x];
      produto.preco = 1 + (x+1 * 0.5);
      produto.descricao = nomeProdutos[x] + ' um produto especialmente escolhido com maior qualidade da nossa horta mais bem cuidada e livre de agrotóxicos!';
      produtos.value.add(produto);
    }
  }
  void zerarCarrinho(){
    produtosCarrinho.assignAll(<Produto>[]);
    indiceTela.value = 0;
    pesquisa.value = '';
    update();
  }
}