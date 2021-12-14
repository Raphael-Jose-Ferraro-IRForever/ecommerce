import 'package:brasil_fields/brasil_fields.dart';
import 'package:ecommerce/controller/controller_get.dart';
import 'package:ecommerce/helpers/size_widgets.dart';
import 'package:ecommerce/models/pedido.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class ItemPedido extends StatelessWidget {

  final ControllerGet controllerGet = Get.put(ControllerGet());
  Pedido pedido;
  BuildContext context;
  Map values = Map();
  List<Widget> escolhas = <Widget>[];

  ItemPedido({required this.pedido, required this.context});

  @override
  Widget build(BuildContext context) {

    List<String> nomeProduto = [];
    List<String> quantProduto = [];
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
    Color cor = Colors.white;

    print('Chave aqui: ' + pedido.estado.toString());
    if (pedido.estado == 'inicial') {
      cor = Colors.deepOrangeAccent;
    } else if (pedido.estado == 'aceito') {
      cor = Colors.blueAccent;
    } else if (pedido.estado == 'saiu') {
      cor = Colors.purple;
    } else if (pedido.estado == 'entregue') {
      cor = Colors.green;
    } else if (pedido.estado == 'cancelado') {
      cor = Colors.red;
    }
    numToString(String total){
      total = total.replaceAll('.', ',');
      if (total.contains(RegExp(r',[0-9]'))) {
        if (total.contains(RegExp(r',[0-9][0-9]')) ) {
        } else{
          total = total + '0';
        }
      }
      if(!total.contains(',')){
        total = total + ',00';
      }
      return total;
    }
    String total = numToString(pedido.total.toString());
    String troco = numToString(pedido.troco == null ? '0,00' :pedido.troco.toString());

    pedido.produtos.forEach((key,value) {
      nomeProduto.add(key);
      Map<String, dynamic> aux = value;
      aux.forEach((key, value) {
        quantProduto.add(key);
      });
    });

    Future<void> gerarPDF() async {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) =>
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(size.paddingPequeno),
                    child: pw.Text('Cliente: \t' +
                        pedido.nomeUsuario.toUpperCase(),
                        style: pw.TextStyle(fontSize: size.textMedio,
                            fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment
                            .spaceBetween,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(
                                size.paddingPequeno),
                            child: pw.Text('Estado: ',
                                style: pw.TextStyle(
                                    fontSize: size.textMedio,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(
                                size.paddingPequeno),
                            child: pw.Text(
                                pedido.estado.toUpperCase(),
                                style: pw.TextStyle(
                                    fontSize: size.textMedio,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Número: ' +
                              pedido.numPedido.toInt().toString(),
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Data: ' + UtilData.obterDataDDMMAAAA(
                              DateTime.parse(pedido.data)) +
                              ' ' + UtilData.obterHoraHHMMSS(
                              DateTime.parse(pedido.data)),
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Pagamento: ' + pedido.pagamento,
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Valor: ' + total,
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Troco: ' + troco,
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                    ],
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: size.paddingMedio,
                      bottom: size.paddingMedio,),
                    child: pw.Text(
                      'Informações do Cliente',
                      style: pw.TextStyle(fontSize: size.textGrande,
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Telefone: ' +
                              pedido.numTelefone,
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Cidade: ' +
                              pedido.endereco['cidade'],
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Bairro ou Distrito: ' +
                              pedido.endereco['bairro'],
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Logradouro: ' +
                              pedido.endereco['rua'],
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Número: ' +
                              pedido.endereco['numero'],
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(size.paddingPequeno),
                        child: pw.Text(
                          'Complemento: ' +
                              pedido.endereco['complemento'],
                          style: pw.TextStyle(fontSize: size.textMedio),
                        ),
                      ),
                    ],
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: size.paddingMedio),
                    child: pw.Text(
                      'Produtos do Pedido',
                      style: pw.TextStyle(fontSize: size.textGrande,
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(
                    height: size.heigth * .13,
                    width: size.width,
                    child: pw.ListView.builder(
                        itemCount: pedido.produtos.length,
                        itemBuilder: (_, index){
                          return pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children:[
                                pw.Text(quantProduto[index] + 'x ',
                                    style: pw.TextStyle(fontSize: size.textGrande)),
                                pw.Text(nomeProduto[index],
                                    style: pw.TextStyle(fontSize: size.textGrande))
                              ]);
                        }),
                  )
                ],
              )
        ),
      );
      String valor = DateTime.now().toString();
      final out = await getApplicationDocumentsDirectory();
      final file = File("${out.path}comprovante-$valor.pdf");
      await file.writeAsBytes(await pdf.save());
      Navigator.of(context).pop();
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
                     Text(
                        'Seu PDF foi salvo na Pasta ${out.path}!',
                        textAlign: TextAlign.center),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                       Navigator.of(context).pop();
                      },
                      child: const Text('OK'))
                ],
              ));

    }

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex:10,
                            child: Text(
                              'Detalhes do Pedido',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: size.textGrande,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red,)
                                , onPressed: (){
                              Navigator.pop(context);
                            }),
                          )
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.paddingPequeno),
                              child: Text('Cliente: \t' +
                                  pedido.nomeUsuario.toUpperCase(),
                                  style: TextStyle(fontSize: size.textMedio,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                          size.paddingPequeno),
                                      child: Text('Estado: ',
                                          style: TextStyle(
                                              fontSize: size.textMedio,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(
                                          size.paddingPequeno),
                                      child: Text(
                                          pedido.estado.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: size.textMedio,
                                              color: cor,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Número: ' +
                                        pedido.numPedido.toInt().toString(),
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Data: ' + UtilData.obterDataDDMMAAAA(
                                        DateTime.parse(pedido.data)) +
                                        ' ' + UtilData.obterHoraHHMMSS(
                                        DateTime.parse(pedido.data)),
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Pagamento: ' + pedido.pagamento,
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Valor: ' + total,
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Troco: ' + troco,
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.paddingMedio,
                                bottom: size.paddingMedio,),
                              child: Text(
                                'Informações do Cliente',
                                style: TextStyle(fontSize: size.textGrande,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Telefone: ' +
                                        pedido.numTelefone,
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Cidade: ' +
                                        pedido.endereco['cidade'],
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Bairro ou Distrito: ' +
                                        pedido.endereco['bairro'],
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Logradouro: ' +
                                        pedido.endereco['rua'],
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Número: ' +
                                        pedido.endereco['numero'],
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(size.paddingPequeno),
                                  child: Text(
                                    'Complemento: ' +
                                        pedido.endereco['complemento'],
                                    style: TextStyle(fontSize: size.textMedio),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.paddingMedio),
                              child: Text(
                                'Produtos do Pedido',
                                style: TextStyle(fontSize: size.textGrande,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: size.heigth * .13,
                              width: size.width,
                              child: ListView.builder(
                                itemCount: pedido.produtos.length,
                                  itemBuilder: (_, index){
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(quantProduto[index] + 'x ',
                                      style: TextStyle(fontSize: size.textGrande)),
                                    Text(nomeProduto[index],
                                        style: TextStyle(fontSize: size.textGrande))
                                  ]);
                              }),
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Voltar',style: TextStyle(color: Colors.red),)),
                        TextButton(
                            onPressed: () {
                              gerarPDF();
                            },
                            child: const Text('Gerar comprovante',style: TextStyle(color: Colors.green),))
                      ],
                    );
                  });
            });
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.only(top: size.paddingGrande, bottom: size.paddingGrande),
          color: cor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: size.paddingGrande*1.5),
                    child: Text(
                      'Número Pedido: ' + pedido.numPedido.toInt().toString(),
                      style: TextStyle(fontSize: size.textMedio, color: Colors.white),
                    ),
                  ),
                  Text(
                    pedido.nomeUsuario,
                    style: TextStyle(fontSize: size.textMedio, color: Colors.white),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: size.paddingGrande*1.5),
                    child: Text(
                      UtilData.obterDataDDMMAAAA(DateTime.parse(pedido.data)).toString(),
                      style: TextStyle(fontSize: size.textMedio, color: Colors.white),
                    ),
                  ),
                  Text(
                    'Valor: ' + pedido.total.toString(),
                    style: TextStyle(fontSize: size.textMedio, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
