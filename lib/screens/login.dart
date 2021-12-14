import 'dart:ui';
import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/route_generator.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/screens/loading.dart';
import 'package:ecommerce/widgets/bubble_indication_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validadores/Validador.dart';
import 'package:validadores/validadores.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyCadastro = GlobalKey<FormState>();

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerEmailLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerSenhaLogin = TextEditingController();

  bool _obscureTextLogin = true;
  bool _validado = true;
  bool _loadingInProgress = true;

  ScrollController? _controller;
  PageController _pageController = PageController();

  Color left = Colors.black;
  Color right = Colors.white;


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

  esqueciSenha() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  }, child: Text('Ok'))
              ],
              title: const Text(
                  'Sucesso!'),
              content: const Text(
                  'Confira sua caixa de entrada e siga os passos para alterar sua senha!'),
            );
          });

        }

  void _dataLoaded() {
    setState(() {
      _loadingInProgress = false;
    });
  }

  _resgatarUsuario() async{
    final ControllerGet controllerGet = Get.put(ControllerGet());
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString('nome') != null){
      controllerGet.cadastrarUser(prefs.getString('nome')!);
    }
    Future.delayed(const Duration(seconds: 3)).then((value) => _dataLoaded());
  }

  _logarCliente() async{

    final prefs = await SharedPreferences.getInstance();

    if((_controllerEmailLogin.text == prefs.getString('email') || _controllerEmailLogin.text == 'user') && (_controllerSenhaLogin.text == prefs.getString('senha') || _controllerSenhaLogin.text == 'user')){
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.ROTA_MENU, (_) => false);
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email e/ou Senha incorretos! Verifique e tente novamente!'),
          duration: Duration(seconds: 3),
        ),
      );

    }

  }


  _criarPreferencias() async {

    final ControllerGet controllerGet = Get.put(ControllerGet());
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nome', _controllerNome.text);
    await prefs.setString('email', _controllerEmail.text);
    await prefs.setString('senha', _controllerSenha.text);

    controllerGet.cadastrarUser(_controllerNome.text);

    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.ROTA_MENU, (_) => false);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _resgatarUsuario();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerSenhaLogin.dispose();
    _controllerEmailLogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_loadingInProgress) {
      return Loading();
    } else {
      return buildLogin();
    }
  }

  Widget buildLogin() {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();

    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
            controller: _controller,
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: size.heigth * .25,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/risedelivery.png',
                        fit: BoxFit.fitWidth,
                        width: size.width * .9,
                      ),
                    ),
                  ),
                  WaveWidget(
                    waveFrequency: 1,
                    waveAmplitude: 5,
                    config: CustomConfig(
                      gradients: [
                        [Color(0xff4f1010), Color(0xff4f1010)],
                        [Color(0xff7a1a1d), Color(0xff33080d)],
                        [Color(0xff7a1a1d), Color(0xff33080d)],
                        [Color(0xff8F2227), Color(0xff7a1a1d)]
                      ],
                      durations: [35000, 19440, 10800, 6000],
                      heightPercentages: [0.15, 0.155, 0.16, 0.165],
                      blur: const MaskFilter.blur(BlurStyle.solid, 4),
                      gradientBegin: Alignment.centerRight,
                      gradientEnd: Alignment.bottomLeft,
                    ),
                    size: Size(size.width, size.heigth * 1.1),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Divider(
                        height: size.heigth * .3,
                        thickness: 0,
                        color: Colors.transparent,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: size.paddingMedio),
                        child: _buildMenuBar(context),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                          width: size.width * .95,
                          height:
                              _validado ? size.heigth * .48 :  size.heigth * .53,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (i) {
                              if (i == 0) {
                                setState(() {
                                  right = Colors.white;
                                  left = Colors.black;
                                  _validado = true;
                                });
                              } else if (i == 1) {
                                setState(() {
                                  right = Colors.black;
                                  left = Colors.white;
                                  _validado = true;
                                });
                              }
                            },
                            children: <Widget>[
                              _buildLogin(context),
                              _buildCadastrarConta(context),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(size.paddingMedio),
                            ),
                              onPressed: () async{
                               //logar
                                final prefs = await SharedPreferences.getInstance();
                                if(prefs.getString('nome') == null) {
                                  _controllerNome.text = 'user';
                                  _controllerEmail.text = 'user';
                                  _controllerSenha.text = 'user';
                                  _criarPreferencias();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Você esta logado como user.'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else{
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, RouteGenerator.ROTA_MENU, (_) => false);
                                }
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left:  size.paddingGrande, right:  size.paddingGrande),
                                      width:  size.width * .3,
                                      color: Colors.white,
                                      child: Image.asset(
                                          'assets/images/google5.gif')))),
                          Padding(
                            padding: EdgeInsets.all(size.paddingMedio),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Clique acima para entrar com o Google',
                                  style: TextStyle(
                                      fontSize:  size.textPequeno, color: Colors.white),
                                ),
                                Icon(
                                  Icons.copyright,
                                  color: Colors.white,
                                  size:  size.textPequeno - 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildMenuBar(BuildContext context) {
    SizeWidgets size = SizeWidgets();

    size = _verificaTela();

    return Container(
      width:  size.width * .7,
      height: size.width * .11,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(
            dy: size.width * .055,
            dxTarget: size.width * .29,
            radius: size.width * .048,
            dxEntry: size.width * .06,
            pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty
                    .all<Color>(Colors.transparent),
                textStyle: MaterialStateProperty.all<
                    TextStyle>(const TextStyle(
                    color: Colors.white,
                  fontFamily: 'Questrial-Regular'
                )),
              ),
              onPressed: _onSignInButtonPress,
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: left,
                  fontSize: size.textGrande,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty
                    .all<Color>(Colors.transparent),
                textStyle: MaterialStateProperty.all<
                    TextStyle>(const TextStyle(
                    color: Colors.white,
                  fontFamily: 'Questrial-Regular'
                )),
              ),
              onPressed: _onSignUpButtonPress,
              child: Text(
                'Criar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: right,
                  fontSize: size.textGrande,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCadastrarConta(BuildContext context) {
    SizeWidgets size = SizeWidgets();

    size = _verificaTela();

    return Padding(
      padding: EdgeInsets.all(size.paddingMedio),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, color: Colors.grey[200]!, spreadRadius: 2),
            ]),
        child: Form(
          key: _formKeyCadastro,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: size.paddingMedio, right: size.paddingMedio, bottom: size.paddingPequeno),
                  child: TextFormField(
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatório')
                          .valido(valor);
                    },
                    controller: _controllerNome,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: size.textMedio),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle, size: size.textGrande,color: temaPadrao.primaryColor,),
                        hintStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(size.paddingMedio, size.paddingGrande, size.paddingMedio, size.paddingGrande),
                        hintText: "nome",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.paddingMedio, right: size.paddingMedio, bottom: size.paddingPequeno),
                  child: TextFormField(
                    validator: (valor) {
                      return Validador()
                          //Em uma situaçao real usaria o validador do email
                          /*.add(Validar.EMAIL,
                              msg: 'Email informado está incorreto!')*/
                          .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatório')
                          .valido(valor);
                    },
                    controller: _controllerEmail,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: size.textMedio),
                    decoration: InputDecoration(
                        hoverColor: Colors.black87,
                        prefixIcon: Icon(Icons.email,size: size.textMedio +1,color: temaPadrao.primaryColor,),
                        hintStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(size.paddingMedio, size.paddingGrande, size.paddingMedio, size.paddingGrande),
                        hintText: "e-mail",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.paddingMedio, right:size.paddingMedio, bottom: size.paddingPequeno),
                  child: TextFormField(
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatório')
                          .valido(valor);
                    },
                    controller: _controllerSenha,
                    keyboardType: TextInputType.text,
                    obscureText: _obscureTextLogin,
                    enableSuggestions: true,
                    style: TextStyle(fontSize: size.textMedio),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: _toggleLogin,
                          child: Icon(
                            _obscureTextLogin
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: size.textPequeno,
                            color: Colors.black,
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock, size: size.textMedio +2,color: temaPadrao.primaryColor,),
                        hintStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(size.paddingMedio, size.paddingGrande, size.paddingMedio, size.paddingGrande),
                        hintText: "senha",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.paddingMedio, right: size.paddingMedio),
                  child: ClipRRect(
                    child: Container(
                      height: size.heigth * .065,
                      width: size.width * .8,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        gradient: LinearGradient(
                          colors: [Color(0xff8F2227), Color(0xffD6333C)],
                        ),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(size.width * .04)),
                          backgroundColor: MaterialStateProperty
                              .all<Color>(Colors.transparent),
                          textStyle: MaterialStateProperty.all<
                              TextStyle>(const TextStyle(
                              color: Colors.white,
                            fontFamily: 'Questrial-Regular'
                          )),
                        ),
                        onPressed: () {
                          if (_formKeyCadastro.currentState!.validate()) {
                           //atualizar o usuario interno
                            _criarPreferencias();
                          } else {
                            setState(() {
                              _validado = false;
                            });
                          }
                        },
                        child: Text('CADASTRAR',
                            style: TextStyle(fontSize: size.textMedio, fontFamily: 'Questrial-Regular', color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _buildLogin(BuildContext context) {
    SizeWidgets size = SizeWidgets();
    size = _verificaTela();

    return Padding(
      padding: EdgeInsets.all(size.paddingMedio),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200]!, blurRadius: 3, spreadRadius: 3),
            ]),
        child: Form(
          key: _formKeyLogin,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: size.paddingMedio, right: size.paddingMedio, bottom: size.paddingMedio),
                  child: TextFormField(
                    validator: (valor) {
                      return Validador()
                      // em uma situacao real usaria a validacao do email
                          /*.add(Validar.EMAIL,
                              msg: 'Email informado está incorreto!')*/
                          .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatório')
                          .valido(valor);
                    },
                    controller: _controllerEmailLogin,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: size.textMedio),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, size: size.textMedio + 1, color: temaPadrao.primaryColor,),
                        hintStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(size.paddingMedio, size.paddingGrande, size.paddingMedio, size.paddingGrande),
                        hintText: "e-mail",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:size.paddingMedio, right: size.paddingMedio, bottom: size.paddingMedio),
                  child: TextFormField(
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatório')
                          .valido(valor);
                    },
                    controller: _controllerSenhaLogin,
                    keyboardType: TextInputType.text,
                    obscureText: _obscureTextLogin,
                    enableSuggestions: true,
                    style: TextStyle(fontSize: size.textMedio),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: _toggleLogin,
                          child: Icon(
                            _obscureTextLogin
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: size.textPequeno,
                            color: Colors.black,
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock, size: size.textMedio + 2, color: temaPadrao.primaryColor,),
                        hintStyle: const TextStyle(
                          color: Colors.black87,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(size.paddingMedio, size.paddingGrande, size.paddingMedio, size.paddingGrande),
                        hintText: "senha",
                        hoverColor: const Color(0xff5C5C5C),
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.paddingMedio, right: size.paddingMedio, bottom: size.paddingMedio),
                  child: ClipRRect(
                    child: Container(
                      height: size.heigth * .065,
                      width: size.width * .8,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        gradient: LinearGradient(
                          colors: [Color(0xffD6333C), Color(0xff8F2227)],
                        ),
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(size.width * .04)),
                          backgroundColor: MaterialStateProperty
                              .all<Color>(Colors.transparent),
                          textStyle: MaterialStateProperty.all<
                              TextStyle>(const TextStyle(
                              color: Colors.white
                          )),
                        ),
                        onPressed: () {
                          if (_formKeyLogin.currentState!.validate()) {
                            // logar cliente
                            _logarCliente();
                          }
                        },
                        child: Text('LOGIN',
                            style: TextStyle(fontSize: size.textMedio, color: Colors.white, fontFamily: 'Questrial-Regular'
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.paddingMedio, right: size.paddingMedio),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Alterar senha de Login'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Digite seu e-mail no campo abaixo que enviaremos um Link para que você possa realizar a altereação da sua senha.'),
                                  Padding(
                                    padding: EdgeInsets.only(top: size.paddingMedio),
                                    child: TextFormField(
                                      validator: (valor) {
                                        //mantive o validador de email pois nesse caso eh apenas uma simulacao e para apresenta-lo
                                        return Validador()
                                            .add(Validar.EMAIL,
                                            msg: 'Email informado está incorreto!')
                                            .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatório')
                                            .valido(valor);
                                      },
                                      controller: _controllerEmailLogin,
                                      enableSuggestions: true,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(fontSize: size.textMedio),
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email, size: size.textMedio + 1,),
                                          hintStyle: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(size.paddingMedio, size.paddingGrande, size.paddingMedio, size.paddingGrande),
                                          hintText: 'Digite aqui',
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => esqueciSenha(),
                                    child: const Text('Enviar'))
                              ],
                            );
                          });
                    },
                    child: Text(
                      'Esqueci minha senha!',
                      style: TextStyle(fontSize: size.textMedio),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
}
