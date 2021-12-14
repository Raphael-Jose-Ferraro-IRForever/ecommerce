import 'package:ecommerce/models/produto.dart';
import 'package:ecommerce/screens/Menu.dart';
import 'package:ecommerce/screens/carrinho.dart';
import 'package:ecommerce/screens/loading.dart';
import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/screens/produtos.dart';
import 'package:flutter/material.dart';

class RouteGenerator {

  static const String ROTA_LOGIN = '/login';
  static const String ROTA_CADASTRO = '/cadastro';
  static const String ROTA_PRODUTO = '/produto';
  static const String ROTA_LOADING = '/loading';
  static const String ROTA_MENU = '/menu';
  static const String ROTA_ITENS_SELECIONAVEIS = '/pedidos-itens-selecionaveis';
  static const String ROTA_ITENS_ADICIONAVEIS = '/pedidos-itens-adicionaveis';
  static const String ROTA_HOME = '/home';
  static const String ROTA_MENUTELA = '/menuTela';
  static const String ROTA_COMPARTILHE= '/perfil-compartilhe';
  static const String ROTA_SOBRE = '/sobre';
  static const String ROTA_CARRINHO = '/carrinho';
  static const String ROTA_EMPRESAESCOLHIDA = '/empresaEscolhida';
  static const String ROTA_NOTIFICACOES = '/notificacoes';
  static const String ROTA_ALTERACADASTRO = '/perfil-cadastro';

  static Route? generateRoute(RouteSettings settings) {

    switch(settings.name){
      case '/':
        return FadeRoute(
            page: Login()
        );

      case ROTA_LOGIN:
        return FadeRoute(
            page: Login()
        );

      /*case ROTA_NOTIFICACOES:
        return FadeRoute(
            page: Notificacoes()
        );*/

      case ROTA_CARRINHO:
        return FadeRoute(
            page: Carrinho()
        );

     case ROTA_PRODUTO:
        return FadeRoute(
            page: Produtos()
        );

      case ROTA_MENU:
        return FadeRoute(
            page: Menu()
        );

      case ROTA_LOADING:
        return MaterialPageRoute(
            builder: (_) => Loading()
        );

      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tela não encontrada!'),
            ),
            body: const  Center(
              child: Text('Tela não encontrada!'),
            ),
          );
        }
    );
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionDuration: Duration(milliseconds: 600),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.bounceOut,
            ),
          ),
          child: child,
        ),
  );
}
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionDuration: Duration(milliseconds: 600),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}