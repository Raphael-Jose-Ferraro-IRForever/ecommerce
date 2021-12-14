import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/route_generator.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/models/endereco.dart';
import 'package:ecommerce/models/pedido.dart';
import 'package:ecommerce/widgets/item_produto_carrinho.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validadores/Validador.dart';

class Carrinho extends StatefulWidget {

  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {

  final ControllerGet controllerGet = Get.put(ControllerGet());
  List<String> opcoesPagamento = ['Dinheiro','Cartão de crédito', 'Cartão de Débito','Pix', 'PicPay'];
  double valorFinal = 0.0;
  double somaProdutos = 0.0;
  double entrega = 2.0;
  bool perderProdutos = false;
  TextEditingController _cupon = TextEditingController();
  TextEditingController _troco = TextEditingController();
  String escolha = 'Dinheiro';
  Endereco endereco = Endereco();

  _preferenciasUser() async {
    final prefs = await SharedPreferences.getInstance();
    perderProdutos = prefs.getBool('perderProdutos') ?? false;
  }

  _alterarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('perderProdutos', perderProdutos);
  }

  _calcularPrecoFinalProdutos() {
    valorFinal = 0.0;
    double somaGeral = 0.0;
    for (var x = 0; x < controllerGet.produtosCarrinho.value.length; x++) {
      somaGeral = somaGeral +
          (controllerGet.contador.value[x] *
              controllerGet.produtosCarrinho.value[x].preco);
    }
    setState(() {
      somaProdutos = somaGeral;
      valorFinal = somaProdutos + entrega;
    });
  }

  _converter(String valor) {
    String moeda = valor;
    moeda = moeda.replaceAll('.', ',');
    if (moeda.contains(RegExp(r',[0-9]'))) {
      if (moeda.contains(RegExp(r',[0-9][0-9]'))) {} else {
        moeda = moeda + '0';
      }
    }
    return moeda;
  }


  _realizarPedidos() async {
    Map<String, dynamic> produtos = <String, dynamic>{};
    Map<String, dynamic> auxiliar = <String, dynamic>{};
    Pedido pedido = Pedido();
    int contador = 0;
    bool sucesso = true;
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text(
                'Realizando seu Pedido!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.paddingGrande * 3, bottom: size.paddingGrande * 3),
                    child: SizedBox(
                      height: size.heigth * .1,
                      width: size.heigth * .1,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  const Text(
                      'Estamos conferindo se está tudo certo e enviando seu pedido...',
                      textAlign: TextAlign.center),
                ],
              ),
            ));

    for (var produto in controllerGet.produtosCarrinho.value) {
      auxiliar = {
        controllerGet.contador.value[contador].toString() : produto.toMap()
      };
      produtos.addAll({
        produto.nome : auxiliar
      });
      contador++;

    }
    double trocoDouble = double.tryParse(_troco.text.replaceAll(',', '.')) ?? 0;
    pedido.total = valorFinal;
    pedido.idPedido = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    pedido.troco = trocoDouble;
    pedido.produtos = produtos;
    pedido.nomeUsuario = controllerGet.nomeUsuario.value;
    pedido.estado = 'inicial';
    pedido.numPedido = controllerGet.pedidos.length + 1;
    pedido.data = DateTime.now().toLocal().toString();
    pedido.endereco = endereco.toMap();
    pedido.pagamento = escolha;
    pedido.numTelefone = '(22)38315023';
    controllerGet.pedidos.value.add(pedido);
     Navigator.pop(context);
    if (sucesso) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                  'Sucesso!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: size.textGrande, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: size.width * .5,
                      width: size.width * .5,
                      child: const FlareActor("assets/animations/sucesso.flr",
                          fit: BoxFit.contain, animation: "Untitled"),
                    ),
                    const Text(
                        'Muito obrigado pela sua compra!',
                        textAlign: TextAlign.center),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        controllerGet.zerarCarrinho();
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteGenerator.ROTA_MENU, (
                            route) => false);
                      },
                      child: const Text('OK'))
                ],
              ));
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                  'Tivemos um problema!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: size.textGrande, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: size.width * .5,
                      width: size.width * .5,
                      child:  Image.asset("assets/images/atencao.png",
                          fit: BoxFit.contain),
                    ),
                    const Text(
                        'Tente novamente!',
                        textAlign: TextAlign.center),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        controllerGet.zerarCarrinho();
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteGenerator.ROTA_MENU, (
                            route) => false);
                      },
                      child: const Text('OK'))
                ],
              ));
    }

  }


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
    _preferenciasUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();
    _calcularPrecoFinalProdutos();
    return WillPopScope(
      onWillPop: _onWillpop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff7a1a1d),
          title: controllerGet.produtosCarrinho.value.length == 0
              ? Text(
            'Carrinho',
            style: TextStyle(
              fontSize: size.textGrande,
            ),
          ) : Text(
            'Escolheu tudo que precisa?',
            style: TextStyle(
              fontSize: size.textMedio,
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: controllerGet.produtosCarrinho.value.length == 0
            ? Container(
          height: size.heigth * .07,
          width: size.width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff7a1a1d),
                    Color(0xffC21A1D),
                  ]
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_outlined, color: Colors.white,
                size: size.width * .05,),
              Icon(Icons.arrow_back_ios_outlined, color: Colors.white,
                size: size.width * .041,),
              Icon(Icons.arrow_back_ios_outlined, color: Colors.white,
                size: size.width * .032,),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.ROTA_MENU, (route) => false);
                },
                child: Text('Retornar ao Menu', style: TextStyle(
                    fontSize: size.textGrande, color: Colors.white
                ),),
              ),
            ],
          ),
        )
            : Container(
          height: size.heigth * .08,
          width: size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffC21A1D),
                    Color(0xffC21A1D),
                    Color(0xffC21A1D),
                    Color(0xffC21A1D),
                    Color(0xffC21A1D),
                    Color(0xffC21A1D),
                    Color(0xffC21A1D),
                    Colors.white,
                    Color(0xff00A930),
                    Color(0xff00A930),
                    Color(0xff00A930),
                    Color(0xff00A930),
                    Color(0xff00A930),
                    Color(0xff00A930),
                    Color(0xff00A930)
                  ])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    !perderProdutos ?
                    controllerGet.produtosCarrinho.value.isEmpty
                        ? Navigator.pushNamedAndRemoveUntil(
                        context, RouteGenerator.ROTA_MENU, (route) => false)
                        : showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text(
                                'Aviso!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: size.textGrande,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/images/atencao.png'),
                                  Text(
                                    'Não feche o App pois perderá os produtos em seu carrinho!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: size.textPequeno),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      perderProdutos = !perderProdutos;
                                      _alterarPreferencia();
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RouteGenerator.ROTA_MENU,
                                              (route) => false);
                                    },
                                    child: Text('Não mostrar novamente',
                                        style: TextStyle(
                                            color: temaPadrao.primaryColor
                                        ))),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RouteGenerator.ROTA_MENU,
                                              (route) => false);
                                    },
                                    child: Text('Tudo Bem', style: TextStyle(
                                        color: temaPadrao.primaryColor
                                    )))
                              ],
                            )) :
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteGenerator.ROTA_MENU, (route) => false)
                    ;
                  },
                  child: const Text(
                    'Continuar Comprando',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                    onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(
                                        'Qual forma de pagamento?',
                                      style: TextStyle(
                                          fontSize: size.textMedio,
                                          fontWeight: FontWeight.bold,
                                      color:
                                        temaPadrao.primaryColor,),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          width: size.width,
                                          height: size.heigth * .07 *
                                              5,
                                          child: ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: 5,
                                              itemBuilder: (_, index) {
                                                return RadioListTile(
                                                    groupValue: escolha,
                                                    value: opcoesPagamento[index],
                                                    title: Text(
                                                      opcoesPagamento[index],
                                                      style: TextStyle(
                                                          fontSize: size
                                                              .textMedio),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        escolha = value.toString();
                                                      });
                                                    });
                                              }),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }, child: const Text('Cancelar',
                                          style: TextStyle(
                                              color: Colors.red))),
                                      TextButton(
                                          onPressed: () {
                                            if (escolha == 'Dinheiro') {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return AlertDialog(
                                                            title: Text(

                                                                'Deseja algum troco?',
                                                              style: TextStyle(
                                                                  fontSize: size
                                                                      .textMedio,
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                              color:
                                                                temaPadrao
                                                                    .primaryColor,
                                                              ),
                                                              textAlign: TextAlign
                                                                  .center,

                                                            ),
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize
                                                                  .min,
                                                              children: <
                                                                  Widget>[
                                                                TextFormField(
                                                                  textAlignVertical: TextAlignVertical
                                                                      .center,
                                                                  validator: (
                                                                      valor) {
                                                                    return Validador()
                                                                        .minLength(
                                                                        1,
                                                                        msg: 'Preencha completamente o campo!')
                                                                        .add(
                                                                        Validar
                                                                            .OBRIGATORIO,
                                                                        msg: 'Campo Obrigatório')
                                                                        .valido(
                                                                        valor);
                                                                  },
                                                                  textInputAction: TextInputAction
                                                                      .done,
                                                                  cursorColor: temaPadrao
                                                                      .primaryColor,
                                                                  controller: _troco,
                                                                  enableSuggestions: true,
                                                                  style: TextStyle(
                                                                    fontSize: size
                                                                        .textPequeno,
                                                                    color: temaPadrao
                                                                        .primaryColor,
                                                                  ),
                                                                  keyboardType: TextInputType
                                                                      .number,
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly,
                                                                    CentavosInputFormatter(
                                                                      casasDecimais: 2
                                                                    ),
                                                                  ],
                                                                  decoration: InputDecoration(
                                                                      hoverColor: temaPadrao
                                                                          .primaryColor,
                                                                      prefixIcon: Icon(
                                                                          FontAwesomeIcons
                                                                              .dollarSign,
                                                                          size: size
                                                                              .textMedio,
                                                                          color: temaPadrao
                                                                              .primaryColor),
                                                                      counterStyle: TextStyle(
                                                                          color: temaPadrao
                                                                              .primaryColor),
                                                                      labelStyle: TextStyle(
                                                                        color: temaPadrao
                                                                            .primaryColor,
                                                                        fontSize: size
                                                                            .textPequeno,
                                                                      ),
                                                                      contentPadding: EdgeInsets
                                                                          .fromLTRB(
                                                                          size
                                                                              .paddingMedio,
                                                                          size
                                                                              .paddingGrande,
                                                                          size
                                                                              .paddingMedio,
                                                                          size
                                                                              .paddingGrande),
                                                                      labelText: 'Troco para qual valor?',
                                                                      filled: true,
                                                                      fillColor: Colors
                                                                          .white24,
                                                                      border: InputBorder
                                                                          .none),
                                                                  textCapitalization: TextCapitalization
                                                                      .sentences,
                                                                ),
                                                                const Text(
                                                                    'Se não deseja troco infome o valor 0'),
                                                              ],
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Cancelar',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red))),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    double trocoDouble = double.tryParse(_troco.text.replaceAll(',','.'))!;
                                                                    if (trocoDouble > valorFinal || trocoDouble == 0.0) {
                                                                        _realizarPedidos();
                                                                      }else{
                                                                        showDialog(
                                                                            barrierDismissible: false,
                                                                            context: context,
                                                                            builder: (context) {
                                                                              return AlertDialog(
                                                                                title: Text('Ops!'),
                                                                                content: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text('Para que você precise de troco o valor digitado tem que ser maior que o total.'),
                                                                                    Text('Valor total atual: $valorFinal.'),
                                                                                    Text('Você pediu troco para: ${trocoDouble}.'),
                                                                                  ],
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Text('OK', style: TextStyle(
                                                                                          color: temaPadrao.primaryColor
                                                                                      ),))
                                                                                ],
                                                                              );
                                                                            });
                                                                      }
                                                                  },
                                                                  child: const Text(
                                                                      'Prosseguir',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .green)))
                                                            ],
                                                          );
                                                        });
                                                  });
                                            } else {
                                              _realizarPedidos();
                                            }
                                          },
                                          child: const Text(
                                              'Prosseguir', style: TextStyle(
                                              color: Colors.green)))
                                    ],
                                  );
                                },
                              );
                            });
                    },
                    child:
                    const Text('Finalizar', style: TextStyle(color: Colors.white))),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.paddingMedio),
            child: Column(
              children: [
                controllerGet.produtosCarrinho.value.isEmpty
                    ? Container(
                  alignment: Alignment.center,
                  height: size.heigth * .45,
                  width: size.width,
                  child: Text('Seu carrinho está vazio!', style: TextStyle(
                      fontSize: size.textGrande, color: temaPadrao.primaryColor
                  ),),
                )
                    : Container(
                  height: size.heigth * .45,
                  width: size.width,
                  child: ListView.builder(
                      itemCount: controllerGet.produtosCarrinho.value.length,
                      itemBuilder: (context, index) {
                        return ItemProdutoCarrinho(
                          remover: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text(
                                        'Aviso!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: size.textGrande,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                              'assets/images/atencao.png'),
                                          Text(
                                            'Tem certeza que deseja remover esse produto?!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: size.textPequeno),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancelar',
                                                style: TextStyle(
                                                    color: Colors.red))),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                controllerGet.produtosCarrinho.value
                                                    .removeAt(index);
                                                controllerGet.contador.value
                                                    .removeAt(index);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Remover',
                                              style:
                                              TextStyle(color: Colors.blue),
                                            ))
                                      ],
                                    ));
                          },
                          contador: controllerGet.contador.value[index],
                          produto: controllerGet.produtosCarrinho.value[index],
                          soma: () {
                            setState(() {
                              controllerGet.contador.value[index]++;
                            });
                          },
                          subtrai: () {
                            if (controllerGet.contador.value[index] != 1) {
                              setState(() {
                                controllerGet.contador.value[index]--;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Para remover o produto aperte no X vermelho acima.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.all(size.paddingMedio),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: size.width * .12,
                        width: size.width * .55,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: temaPadrao.primaryColor,
                          controller: _cupon,
                          enableSuggestions: true,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          style: TextStyle(
                            fontSize: size.textPequeno,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Cupon promocional',
                            prefixIcon: Icon(
                              Icons.card_giftcard,
                              size: size.textPequeno,
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      ButtonTheme(
                        minWidth: size.width * .3,
                        height: size.heigth * .06,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.all(size.width * .04)),
                            backgroundColor: MaterialStateProperty
                                .all<Color>(temaPadrao.primaryColor),
                            textStyle: MaterialStateProperty.all<
                                TextStyle>(const TextStyle(
                                color: Colors.white
                            )),
                          ),
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text(
                                        'Aviso!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: size.textGrande,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                              'assets/images/atencao.png'),
                                          Text(
                                            'Não temos nenhum cupon com esse nome ativo no momento!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: size.textPequeno),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'))
                                      ],
                                    ));
                          },
                          child: Text(
                            'Aplicar',
                            style: TextStyle(fontSize: size.textPequeno,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: size.heigth * .3,
                  width: size.width,
                  child: Card(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(size.paddingGrande),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: size.paddingGrande * 1.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    'Soma de Produtos',
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                  Text(
                                    'R\$' + _converter(somaProdutos.toString()),
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: size.paddingGrande * 1.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    'Valor da Entrega',
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                  Text(
                                    'R\$' + _converter(entrega.toString()),
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: size.paddingGrande * 1.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    'Desconto do Cupon',
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                  Text(
                                    'R\$' + _converter(0.0.toString()),
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                height: 5,
                                child: Divider(
                                  height: size.width * 2,
                                  thickness: 2,
                                  color: Colors.black54,
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.paddingGrande * 1.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    'Total do Pedido',
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                  Text(
                                    'R\$' + _converter(valorFinal.toString()),
                                    style: TextStyle(
                                        fontSize: size.textMedio,
                                        color: temaPadrao.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
